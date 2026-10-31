#!/usr/bin/env nu

def get-test-files [config_dir: path]: nothing -> list<string> {
    ls $config_dir
    | where name ends-with ".nu"
    | where name !~ "test-runner.nu"
    | get name
}

def find-tests-in-file [file: path]: nothing -> list<record> {
    let content = open --raw $file
    let tests = ($content
        | lines
        | where $it =~ '^(export )?def test[-_]'
        | parse --regex '^(?:export )?def (?<test_name>test[-_][\w-]+)'
        | get test_name)
    if ($tests | is-empty) {
        return []
    }
    [
        {file: $file, tests: $tests}
    ]
}

def discover-all-tests []: list<string> -> list<record> {
    each {|file| find-tests-in-file $file }
    | flatten
}

def run-test [file: path, test_name: string]: nothing -> record {
    let command = $"source '($file)'; ($test_name)"
    let result = (^nu --no-config-file --commands $command | complete) # nu-lint-ignore: redundant_nu_subprocess
    {
        passed: ($result.exit_code == 0)
        error: $result.stderr
    }
}

def run-file-tests []: record -> list<record> {
    let item = $in
    $item.tests
    | each {|test|
        let result = (run-test $item.file $test)
        {
            file: $item.file
            test: $test
            passed: $result.passed
            error: $result.error
        }
    }
}

def run-all-tests []: list<record> -> list<record> {
    each {|item| $item | run-file-tests }
    | flatten
}

def count-results [results: list<record>]: nothing -> record {
    let passed = ($results | where passed | length)
    let failed = ($results | where not $it.passed | length)
    {passed: $passed, failed: $failed}
}

def print-results-by-file []: list<record> -> nothing {
    let files = ($in | group-by file | items {|file_path, tests| {file: $file_path, tests: $tests} })
    for file in $files {
        print ($file.file | path basename)
        for result in $file.tests {
            print $"  ▶ ($result.test)"
            if $result.passed {
                print "    ✓ passed"
            } else {
                print $"    ✗ failed: ($result.error)"
            }
        }
        print ""
    }
}

def main []: nothing -> nothing {
    let config_dir = $"($env.HOME)/.config/nushell"
    let nu_files = (get-test-files $config_dir)
    print $"Scanning ($nu_files | length) Nushell files for tests...\n"
    let all_tests = ($nu_files | discover-all-tests)
    if ($all_tests | is-empty) {
        print "No tests found."
        return
    }
    let total_tests = ($all_tests | each {|item| $item.tests | length } | math sum)
    print $"Found ($total_tests) tests in ($all_tests | length) files\n"
    let results = ($all_tests | run-all-tests)
    $results | print-results-by-file
    let counts = (count-results $results)
    print $"Results: ($counts.passed) passed, ($counts.failed) failed"
    if $counts.failed > 0 {
        exit 1
    }
}
