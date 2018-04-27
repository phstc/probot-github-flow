const handlePullRequestReview = require('../../lib/handlePullRequestReview')
const { REVIEW_REQUESTED, REJECTED } = require('../../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'
const number = '1234'
const pullRequest = {
  body: `Closes #${number}`,
  merged: true,
  number: '5678'
}
const github = {}

jest.mock('../../lib/utils/labels', () => ({
  removeLabels: jest.fn(),
  addLabels: jest.fn()
}))

const { removeLabels, addLabels } = require('../../lib/utils/labels')

beforeEach(() => {
  addLabels.mockReset()
  removeLabels.mockReset()
})

test('reject related issues', async () => {
  await handlePullRequestReview(github, owner, repo, {
    pull_request: pullRequest,
    review: { state: 'changes_requested' }
  })

  expect(addLabels).toBeCalledWith(github, owner, repo, number, [REJECTED])
})

test('approve related issues', async () => {
  await handlePullRequestReview(github, owner, repo, {
    pull_request: pullRequest,
    review: { state: 'approved' }
  })

  expect(removeLabels).toBeCalledWith(github, owner, repo, number, [
    REVIEW_REQUESTED,
    REJECTED
  ])
})
