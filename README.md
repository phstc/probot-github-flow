[![Build Status](https://travis-ci.com/phstc/probot-github-flow.svg?token=CYHU2osEpniE1dbxzZ6K&branch=master)](https://travis-ci.com/phstc/probot-github-flow)

# GitHub Flow

GitHub Flow based on Issues and Pull Requests.

1.  File an Issue
2.  Create a Pull request with `Fixes #issue-number` (or [any other closing keyword](https://help.github.com/articles/closing-issues-using-keywords/))
    1.  GitHub Flow labels the Issue with `in progress`,
    2.  adds the Pull request author as an Issue assignee
3.  Once your Pull request is ready for review, [ask for a Reviewer](https://help.github.com/articles/about-pull-request-reviews/)
    1.  GitHub Flow labels the Issue with `ready for review`, `review requested` and removes `in progress`
    2.  If the Reviewer requests changes, GitHub Flow labels the Issue with `rejected` and removes `ready for review`
4.  Once the Pull request is merged,
    1.  GitHub Flow closes the Issue,
    2.  removes the label `ready for review`, `rejected` and `review requested`
    3.  and removes the Pull request branch.

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

> GitHub flow is built with [probot](https://github.com/probot/probot).
