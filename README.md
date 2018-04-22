### Usage

1.  Create an issue
2.  Create a PR with `Fixes #number`
3.  PutsLabel will label the issue with `in progress`, add you (PR author) as an assignee and append the PR link in the issue description
4.  Ask someone to review your PR
5.  PutsLabel will label the issue with `review requested` and `ready for review`, and remove `in progress`
6.  If the reviewer requests changes, PutsLabel will remove `ready for review` and label the issue with `rejected`
7.  If the reviewer approves the PR, PutsLabel will remove `rejected` (in case it was previously rejected) and `review requested`
8.  Once the PR is merged, PutsLabel will clean up the issue removing all labels it has added

### Getting Started

First

```shell
bundle install
```

Then

```shell
bundle exec dotenv shotgun -p 4567
```

### Deploy

Production URL: https://putslabel.herokuapp.com/

#### Production

```shell
git push prd master
```

#### Staging

Staging URL: https://putslabel-stg.herokuapp.com/

```shell
git push stg master
```

