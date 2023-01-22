#!/bin/bash

worktree-traveler() {

  1>/dev/null git status || return
  1>/dev/null git worktree list || return

  frost1="#8FBCBB"
  work_tree_root=($(git worktree list --porcelain | head -n 1))
  root_dir=${work_tree_root[2]}

  frost() {
    text=$1
    gum style --foreground "$frost1" "$text"
  }

  frost_choose() {
    gum choose --cursor.foreground "$frost1" --selected.foreground "$frost1" "$@"
  }

  get_worktrees() {
      frost_choose $(git worktree list --porcelain | tail -n +4 | grep -o ' /[^"]*' | while read dir; do basename -- "$dir"; done)
  }

  get_outside_branches() {
      worktrees=$(git worktree list --porcelain | tail -n +4 | grep -o ' /[^"]*' | while read dir; do basename -- "$dir"; done | tr "\n" " " | xargs | tr " " "|")
      frost_choose $(git branch -a --format="%(refname:short)" | grep -vwE "$worktrees")
  }

  gum style \
    --border normal \
    --border-foreground "#88C0D0" \
    --margin "1 2" \
    --padding "2 3" \
    " $(frost Worktree) Traveler"


  echo "Choose $(frost operation)"
  command=$(frost_choose add checkout new remove)

  case $command in
      add)
          echo "Choose $(frost "branch")"
          branch=$(get_outside_branches)
          echo "Adding worktree from branch $(frost "$branch")"
          git worktree add "$root_dir/$branch" "$branch"
          cd "$root_dir/$branch"
          ;;
      checkout)
          echo "Choose $(frost "branch")"
          branch=$(get_worktrees)
          echo "Moving to worktree $(frost "$branch")"
          cd "$root_dir/$branch"
          ;;
      new)
          echo "Choose $(frost "branch") name"
          branch=$(gum input --placeholder "master...")
          git worktree add -B "$branch" "$root_dir/$branch"
          cd "$root_dir/$branch"
          ;;
      remove)
          echo "Choose $(frost branch)"
          branch=$(get_worktrees)
          echo "Removing worktree $(frost "$branch")"
          git worktree remove "$root_dir/$branch"
          ;;
  esac


}
