#!/bin/bash

function worktree-traveler() {


  frost1="#8FBCBB"
  dark3="#81A1C1"

  function has_git() {
    &>/dev/null git --work-tree="." status
  }

  function has_worktree() {
    &>/dev/null git --work-tree="." worktree list
  }

  function frost() {
    text=$1
    gum style --foreground "$frost1" "$text"
  }

  function gray() {
    text=$1
    gum style --foreground "$dark3" "$text"
  }

  function frost_choose() {
    gum choose --cursor.foreground "$frost1" --selected.foreground "$frost1" "$@"
  }

  function frost_confirm() {
    gum confirm --selected.background "#8FBCBB" --unselected.background "#2E3440" -- $@
  }

  function get_worktrees() {
      frost_choose $(git worktree list --porcelain | tail -n +4 | grep -o ' /[^"]*' | while read dir; do basename -- "$dir"; done)
  }

  function get_outside_branches() {
      worktrees=$(git worktree list --porcelain | tail -n +4 | grep -o ' /[^"]*' | while read dir; do basename -- "$dir"; done | tr "\n" " " | xargs | tr " " "|")
      frost_choose $(git branch -a --format="%(refname:short)" | grep -vwE "$worktrees")
  }

  function get_branches() {
    frost_choose $(git branch -a --format="%(refname:short)")
  }

  gum style \
    --border normal \
    --border-foreground "#88C0D0" \
    --margin "1 2" \
    --padding "2 3" \
    " $(frost Worktree) Traveler"

  echo "Choose $(frost "operation")"
  if has_worktree; then
    work_tree_root=($(git worktree list --porcelain | head -n 1))
    root_dir=${work_tree_root[2]}
    command=$(frost_choose checkout add new rename remove)
  elif ! has_git; then
    command=$(frost_choose init)
  else
    return
  fi

  case $command in
      add)
          echo "Choose $(frost "branch")"
          if ! branch=$(get_outside_branches); then
            echo $(gray "\nNo missing upstream branches to add")
            return
          fi
          echo "Adding worktree from branch $(frost "$branch")"
          git worktree add "$root_dir/$branch" "$branch"
          cd "$root_dir/$branch"
          ;;
      checkout)
          echo "Choose $(frost "branch")"
          branch=$(get_worktrees) || return
          echo "Moving to worktree $(frost "$branch")"
          cd "$root_dir/$branch" || return
          ;;
      new)
          echo "Choose $(frost "branch") name"
          branch=$(gum input --placeholder "new branch...") || return
          git worktree add -b "$branch" "$root_dir/$branch" || return
          cd "$root_dir/$branch" || return
          ;;
      rename)
          echo "Choose $(frost "branch")"
          branch=$(get_branches)
          echo "Choose new $(frost "branch") name"
          new_branch=$(gum input --placeholder "new branch...")
          cd "$root_dir"
          git branch -m "$branch" "$new_branch"
          if $(&>/dev/null [ -d "$root_dir/$branch" ]); then
            git worktree move "$root_dir/$branch" "$root_dir/$new_branch"
          fi
          cd "$root_dir/$new_branch"
          ;;
      remove)
          echo "Choose $(frost branch)"
          branch=$(get_worktrees) || return
          frost_confirm && git worktree remove "$root_dir/$branch"
          ;;
      init)
          if frost_confirm "Init project in current directory?"; then
            frost_confirm "Confirm init in $(pwd)" && git init --bare || return
          else
            echo "Choose $(frost "project directory")"
            dir=$(gum input --placeholder "my_project...") || return
            frost_confirm "Confirm init in $(pwd)/$dir" && git init --bare "$dir" && cd "$dir" || return
          fi

          git --work-tree="." commit --allow-empty -m "Project init"
          branch=$(git config --global --get init.defaultBranch || echo "master")
          git worktree add $branch $branch && cd $branch
          ;;
  esac
}
