# How to contribute

## Documentation

The documentation is mandatory for every function corresponding to the code rules. Everyone must be able to understand the utility of the function just by reading the function’s documentation.

## Issue Rules

### When creating an issue, you must follow the given format :

- The issue name must be as clear and understandable as possible :

  `Create the Contributing.md`

- Describing the issue is mandatory and useful for everyone. Using a template for your issue is recommended.
- Add corresponding labels to clarify the issue. If there is no label existing or corresponding to your issue, create one and describe it.
- Take a moment to link the issue with the project, if it hasn't been done automatically.

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

    git checkout -b feature/2-create-the-contributing.md

You must make one branch per issue.

Try to push as regularly as possible so everyone can see where you are at. When first committing to a branch, it is recommended to open a PR draft, so it will be easier for your mates to see where you are at.

## Commit Rules

They should always look like the following description :

  - Add a new feature -> `[ADD] Commit message`
  - Fix a bug -> `[FIX] Commit message`
  - Remove code -> `[REMOVE] Commit message`
  - Update code -> `[UPDATE] Commit message`

Please specify shortly (in english) what your commit is doing (this will be useful for the reviews).

This should look like this:

    `git commit -m "Add new rules to the CONTRIBUTING.md`

    `Add Committing Rules"`

You should always commit frequently and based on the given example.

If possible, please certify your commits (-S).

## Pull Request Rules

/!\ Make sure to respect the order when merge : (Test -> Prod -> Main)

- Work on `Test` has to be tested before merged on `Prod`
- Work on `Prod` has to be deployed before merged on `Main`

When your work is done on a branch, you must make a pull request.

The name is the same for the branch. However, you must write a description as a reminder of what you have done. It may be all about the issue, but often you have unexpected fixes.

For the reviewers, prioritize the people who can really help you with your work.

You must have at least 2 reviewers who approve your pull request.

Try not to exceed 24 hours before reading your PRs.

It is obviously forbidden to approve a merge until all the reviewers have accepted the PR as well as the success of the workflows.
