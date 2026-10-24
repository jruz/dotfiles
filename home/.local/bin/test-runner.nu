#!/usr/bin/env nu

def get-test-files [config_dir: string] {
    ls $config_dir
    | where name ends-with ".nu"
    | where name !~ "test-runner.nu"
    | get name
}

def find-tests-in-file [file: string] {
    let tests = open $file
    | lines
    | where $it =~ '^(export )?def test_'
    | parse --regex '^(?:export )?def (?<test_name>test_\w+)'
    | get test_name

    if ($tests | is-not-empty) {
        { file: $file, tests: $tests }
    } else {
        null
    }
}

def discover-all-tests [files: list<string>] {
    $files
    | each { |file| find-tests-in-file $file }
    | compact
}

def run-test [file: string, test_name: string] {
    try {
        ^nu --commands $"source ($file); ($test_name)" | complete
        { passed: true, error: null }
    } catch { |err|
        { passed: false, error: $err.msg }
    }
}

def run-all-tests [test_items: list] {
    $test_items
    | each { |item|
        $item.tests
        | each { |test|
            let result = run-test $item.file $test
            {
                file: $item.file
                test: $test
                passed: $result.passed
                error: $result.error
            }
        }
    }
    | flatten
}

def count-results [results: list] {
    let passed = $results | where passed == true | length
    let failed = $results | where passed == false | length
    { passed: $passed, failed: $failed }
}

def print-results-by-file [results: list] {
    $results
    | group-by file
    | transpose file_path tests
    | each { |group|
        let file_name = $group.file_path | path basename
        print $"($file_name)"
        $group.tests | each { |result|
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

def main [] {
    let config_dir = $"($env.HOME)/.config/nushell"

    let nu_files = get-test-files $config_dir
    print $"Scanning ($nu_files | length) Nushell files for tests...\n"

    let all_tests = discover-all-tests $nu_files

    let total_tests = if ($all_tests | is-empty) {
        0
    } else {
        $all_tests | each { |item| $item.tests | length } | math sum
    }

    if $total_tests == 0 {
        print "No tests found."
        return
    }

    print $"Found ($total_tests) tests in ($all_tests | length) files\n"

    let results = run-all-tests $all_tests
    print-results-by-file $results

    let counts = count-results $results
    print $"Results: ($counts.passed) passed, ($counts.failed) failed"

    if $counts.failed > 0 {
        exit 1
    }
}
