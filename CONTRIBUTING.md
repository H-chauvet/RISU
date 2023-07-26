# How to contribute

## Documentation

The documentation is mandatory for every function corresponding to the code rules. Everyone must be able to understand the utility of the function just by reading the function’s documentation.

## Branch Rules

The branch name must have a keyword before
  - feature -> `For a new feature / functionnality`
  - fix -> `For a bug resolution`
  - refacto -> `For a refactorization of code`
  - test -> `For tests of code (Unit tests, functional tests etc..)`
  - docs -> `For documentation of code`

The branch name should consider the issue title and the issue number in its name. The issue's number must come first, after the keyword.
Every single word must be in lowercase.

Example:

    git checkout -b feature/2
Where :

`2` is the id of the User-Story on Taiga

You must make one branch per User-Story, not per task linked to User-Story.

Try to push as regularly as possible so everyone can see where you are at. When first committing to a branch, it is recommended to open a PR draft, so it will be easier for your mates to see where you are at.

## Commit Rules

They should always look like the following description :

  - Add a new feature -> `[ADD] Commit message`
  - Fix a bug -> `[FIX] Commit message`
  - Remove code -> `[REMOVE] Commit message`
  - Update code -> `[UPDATE] Commit message`

You should always commit frequently and based on the given example.

If possible, please certify your commits (-S).

## Pull Request Rules

/!\ Make sure to respect the order when merge : (Your branch -> dev -> Main)

- Work on `Your branch` then, when it's done, Pull-Request to `dev`
- When CI passed on the Pull-Request from `Your branch` to `dev`, merge the work on `Main`

- If you want to deploy the work on `dev`, open a Pull-Request from `dev` to `main`
- When CI passed on the Pull-Request from `dev` to `main`, merge the work on `Main`, and the deployement will be done.

When your work is done on a branch, you must make a pull request.

The name is the same for the branch. However, you must write a description as a reminder of what you have done. It may be all about the issue, but often you have unexpected fixes.

For the reviewers, prioritize the people who can really help you with your work.

You must have at least 2 reviewers who approve your pull request.

Try not to exceed 24 hours before reading your PRs.

It is obviously forbidden to approve a merge until all the reviewers have accepted the PR as well as the success of the workflows.
