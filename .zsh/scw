# vi:syntax=sh
scwdiff() {
  diff="log --color -p --oneline --stat"
  session=$(tmux display-message -p '#S')
  if [[ $1 == "" ]]; then
    challenge=$(get_parent_challenge)
  else
    challenge=$(get_challenge_name $1)
  fi
  tmux new-window -t ${sesion}:0 -n ${challenge} "git $diff master..${challenge}"
  tmux split-window -t ${sesion}:0 -h "git $diff ${challenge}..${challenge}_incorrect_0";
  tmux split-window -t ${sesion}:0.1 -v "git $diff ${challenge}..${challenge}_secure";
  tmux split-window -t ${sesion}:0.2 -v -p 66 "git $diff ${challenge}..${challenge}_incorrect_1";
  tmux split-window -t ${sesion}:0.4 -v "git $diff ${challenge}..${challenge}_incorrect_2";
}

scwdiff2() {
  diff="log --color -p --oneline --stat"
  session=$(tmux display-message -p '#S')
  if [[ $1 == "" ]]; then
    challenge=$(get_parent_challenge)
  else
    challenge=$(get_challenge_name $1)
  fi
  tmux new-window -t ${sesion}:0 -n ${challenge} "git $diff secure..${challenge}"
  tmux split-window -t ${sesion}:0 -h "git $diff ${challenge}..${challenge}_incorrect_0";
  tmux split-window -t ${sesion}:0.1 -v "git diff ${challenge}..secure";
  tmux split-window -t ${sesion}:0.2 -v -p 66 "git $diff ${challenge}..${challenge}_incorrect_1";
  tmux split-window -t ${sesion}:0.4 -v "git $diff ${challenge}..${challenge}_incorrect_2";
}

mindiff() {
  diff="diff"
  session=$(tmux display-message -p '#S')
  if [[ $1 == "" ]]; then
    challenge=$(get_parent_challenge)
  else
    challenge=$(get_challenge_name $1)
  fi
  tmux new-window -t ${sesion}:0 -n ${challenge} "git $diff master..${challenge}"
  tmux split-window -t ${sesion}:0 -h "git $diff ${challenge}..${challenge}_incorrect_0";
  tmux split-window -t ${sesion}:0.1 -v "git $diff ${challenge}..${challenge}_secure";
  tmux split-window -t ${sesion}:0.2 -v -p 66 "git $diff ${challenge}..${challenge}_incorrect_1";
  tmux split-window -t ${sesion}:0.4 -v "git $diff ${challenge}..${challenge}_incorrect_2";
}

challenge_log() {
  repo="/home/jruz/dev/freelance/scw/sinatra"
  branch="oldmaster"
  printf "base\n"
  git --no-pager -C $repo log --pretty=format:"%h | %s" --date="short" $branch..$1
  printf "\n\nincorrect_0\n"
  git --no-pager -C $repo log --pretty=format:"%h | %s" --date="short" $branch..$1_incorrect_0
  printf "\n\nincorrect_1\n"
  git --no-pager -C $repo log --pretty=format:"%h | %s" --date="short" $branch..$1_incorrect_1
  printf "\n\nincorrect_2\n"
  git --no-pager -C $repo log --pretty=format:"%h | %s" --date="short" $branch..$1_incorrect_2
  printf "\n\nsecure\n"
  git --no-pager -C $repo log --pretty=format:"%h | %s" --date="short" $branch..$1_secure
  printf "\n"
}

get_parent_challenge() {
  git rev-parse --abbrev-ref HEAD | sed -r 's/_(incorrect|secure)(_[0-2])?//g'
}

push_challenge_branches() {
  git branch | grep $1 | awk '{gsub("*","",$0); system( "git push -uf origin "$1 )}'
}

push_current_challenge_branches() {
  push_challenge_branches $(get_parent_challenge)
}

go_to_challenge_version(){
  branch=""
  if [[ $1 =~ "[0-9]" ]]; then
    branch="_incorrect_$1"
  elif [[ $1 == "s" ]]; then
    branch="_secure"
  fi
  git checkout $(get_parent_challenge)$branch
}

resetchildren() {
  branch=$(get_parent_challenge)
  git branch -f ${branch}_incorrect_0 $branch
  git branch -f ${branch}_incorrect_1 $branch
  git branch -f ${branch}_incorrect_2 $branch
  #git branch -f ${branch}_secure $branch
}

reset_parent_to() {
  git reset --hard master
  git cherry-pick $1
}

rebase_to_parent() {
  git rebase $(get_parent_challenge)
}

mini_challenge_log() {
  echo $(git --no-pager log -n 1 --format="%h | P | %s" $1)
  echo $(git --no-pager log -n 1 --format="%h | 0 | %s" $1_incorrect_0)
  echo $(git --no-pager log -n 1 --format="%h | 1 | %s" $1_incorrect_1)
  echo $(git --no-pager log -n 1 --format="%h | 2 | %s" $1_incorrect_2)
  echo $(git --no-pager log -n 1 --format="%h | S | %s" $1_secure)
}

current_mini_challenge_log() {
  mini_challenge_log $(get_parent_challenge)
}

current_challenge_log() {
  challenge_log $(get_parent_challenge)
}

get_challenge_name() {
  git branch | grep "[^t]_$1$" | awk '{gsub("*","",$0); print( $1 )}'
}

go_to_challenge (){
  git checkout $(get_challenge_name $1)
}


get_secure_files() {
  rails='/home/jruz/dev/freelance/scw/rails'
  minified='/home/jruz/dev/freelance/scw/rails-minified'
  for i in {0..59}
  do
    branch=$(get_challenge_name $i)
    git branch -f ${branch}_secure $branch
    git checkout ${branch}_secure
    git -C $rails checkout ${branch}_secure
    git -C $rails --no-pager diff --name-only HEAD^ HEAD | awk '{system("cp "rails"/"$1" "minified)}' minified="$minified" rails="$rails"
    git add -A
    git commit -m "secure fix"
    git push
  done
}

show_lines_for() {
  challenge=$(get_challenge_name $1)
  git --no-pager diff ${challenge}^ $challenge | grep -E "@@|---" | awk '{gsub(/ @@ .*|a\/|@@/,"",$0); print($0)}'
}


force_push_challenges() {
  git branch | grep $1 | awk '{gsub("*","",$0); system( "git push -f origin "$1 )}'
}

force_push_current_challenges() {
  force_push_challenges $(get_parent_challenge)
}

rebase_from_secure(){
 git rebase secure
  for i in {0..2}
  do
    go_to_challenge_version $i
    rebase_to_parent
  done
  go_to_challenge_version
}
