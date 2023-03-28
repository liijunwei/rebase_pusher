# RebasePusher

rebase all my branches to default branch and force push them to remote

## Installation

```bash
gem install rebase_pusher
```

## Usage

```bash
rebase_push -h
```

Note: cant use thread to speed it up as git operations have lock applied

## Warning

make sure **all your changes** have been committed and pushed to remote repository before running `reset/rebase/force_push`
