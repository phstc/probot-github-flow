const handlePullRequestClosed = require('../lib/handlePullRequestClosed')

const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('../lib/constants')

const owner = 'owner'
const repo = 'repo'
const number = '1234'
const pullRequest = {
  body: `Closes #${number}`,
  merged: true
}

const github = {
  issues: {
    get: jest.fn().mockReturnValue({ number }),
    edit: jest.fn()
  }
}

jest.mock('../lib/labels', () => ({
  removeLabels: jest.fn()
}))
const { removeLabels } = require('../lib/labels')

test('closes related issues', async () => {
  handlePullRequestClosed(github, owner, repo, pullRequest)

  const labels = [IN_PROGRESS, READY_FOR_REVIEW, REVIEW_REQUESTED, REJECTED]

  expect(removeLabels).toBeCalledWith(github, owner, repo, number, labels)

  // expect(github.issues.get).toBeCalledWith({
  //   owner,
  //   repo,
  //   number
  // })

  // expect(github.issues.get).toBeCalledWith({
  //   owner,
  //   repo,
  //   number
  // })
})
