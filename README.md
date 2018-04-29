[![Build Status](https://travis-ci.com/phstc/putslabel.svg?token=CYHU2osEpniE1dbxzZ6K&branch=master)](https://travis-ci.com/phstc/putslabel)

# PutsLabel

We use GitHub Issues for tracking features, bugs, enhancements etc, everything we change in the code, there's a referenced Issue, and for changing code, we create Pull requests.

1.  File an Issue
2.  Create a Pull request with `Fixes #issue-number` (or [any other closing keyword](https://help.github.com/articles/closing-issues-using-keywords/))
    1. PutsLabel labels the Issue with `in progress`,
    2. adds the Pull request author as an Issue assignee
    3. and updates the Issue description with `PR: #pull-request-number`.
3.  Once your Pull request is ready for review, [ask for a Reviewer](https://help.github.com/articles/about-pull-request-reviews/)
    1. PutsLabel labels the Issue with `ready for review`, `review requested` and removes `in progress`
    2. If the Reviewer requests changes, PutsLabel labels the Issue with `rejected` and removes `ready for review`
4.  Once the Pull request is merged, PutsLabel closes the Issue and removes the label `ready for review`, `rejected` and `review requested`

> PutsLabel is built with [probot](https://github.com/probot/probot).

## Setup

```sh
# Install dependencies
yarn install

# Run the bot in development
yarn dev

# Run the bot in production
yarn start

# Run the tests
yarn test
```

See [docs/deploy.md](docs/deploy.md) if you would like to run your own instance of this app.
