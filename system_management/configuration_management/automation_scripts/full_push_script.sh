#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 '<commit-message>'"
    exit 1
fi

COMMIT_MESSAGE=$1

check_git_repository() {
    if [ ! -d .git ]; then
        echo "Error: No Git repository found in the current directory."
        exit 2
    fi
}

check_dvc_initialized() {
    if [ ! -d .dvc ]; then
        echo "DVC is not initialized in this repository."
        exit 1
    fi
}

auto_dvc_add() {
    IFS=$'\n'  # change the field separator to handle paths with spaces
    for path in $(dvc status | grep 'not in cache' | awk '{print $1}'); do
        echo "Adding $path to DVC..."
        dvc add "$path"
        if [ $? -ne 0 ]; then
            echo "Failed to add $path to DVC."
            exit 2
        fi
    done
    unset IFS
}

show_status() {
    echo "Git Status:"
    git status
    if [ -d .dvc ]; then
        echo "DVC Status:"
        dvc status
    fi
}

confirm_action() {
    show_status
    echo "You are about to add all changes to Git and DVC, commit them with the message '$COMMIT_MESSAGE', and push to the remote repositories."
    echo "Do you want to proceed? (y/N)"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            echo "Operation aborted."
            exit 0
            ;;
    esac
}

push_changes() {
    echo "Adding changes to DVC..."
    dvc add .
    echo "Adding all changes to Git..."
    git add .

    echo "Committing changes..."
    git commit -m "$COMMIT_MESSAGE"

    echo "Pushing changes to Git remote..."
    git push

    echo "Pushing changes to DVC remote..."
    dvc push

    echo "All changes have been successfully pushed."
}

check_git_repository
check_dvc_initialized
confirm_action
auto_dvc_add
push_changes
