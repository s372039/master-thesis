#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 '<branch_or_commit_hash>'"
    exit 1
fi

TARGET=$1

check_git_repository() {
    if [ ! -d .git ]; then
        echo "Error: No Git repository found in the current directory."
        exit 2
    fi
}

check_dvc_initialized() {
    if [ ! -d .dvc ]; then
        echo "Warning: DVC is not initialized in this repository."
    fi
}

confirm_action() {
    echo "You are about to checkout to '$TARGET' and sync DVC tracked files."
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

git_checkout() {
    git checkout $TARGET
    if [ $? -ne 0 ]; then
        echo "Git checkout failed."
        exit 3
    fi
}

dvc_checkout() {
    if [ -d .dvc ]; then
        dvc checkout
        if [ $? -ne 0 ]; then
            echo "DVC checkout encountered a problem."
            exit 4
        fi
    fi
}

check_git_repository
check_dvc_initialized
confirm_action
git_checkout
dvc_checkout

echo "Checkout to '$TARGET' was successful."
