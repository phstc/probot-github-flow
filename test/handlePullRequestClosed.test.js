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
  merged: true,
  number: '5678'
}

const github = {
  issues: {
    get: jest.fn(),
    edit: jest.fn()
  }
}

jest.mock('../lib/issues', () => ({
  removeLabels: jest.fn()
}))

const { removeLabels } = require('../lib/issues')

beforeEach(() => {
  removeLabels.mockReset()
  github.issues.get.mockReset()
  github.issues.edit.mockReset()
})

test('merged pull request', async () => {
  github.issues.get.mockReturnValue({
    body: `**PR:** #${pullRequest.number}`
  })

  await handlePullRequestClosed(github, owner, repo, {
    pull_request: pullRequest
  })

  const labels = [IN_PROGRESS, READY_FOR_REVIEW, REVIEW_REQUESTED, REJECTED]

  expect(removeLabels).toBeCalledWith(github, owner, repo, number, labels)

  expect(github.issues.get).toBeCalledWith({
    owner,
    repo,
    number
  })

  const body = `<strike>**PR:** #${pullRequest.number}</strike>`

  expect(github.issues.edit).toBeCalledWith({
    owner,
    repo,
    number,
    body,
    status: 'closed'
  })
})

test('unmerged pull request', async () => {
  pullRequest.merged = false

  await handlePullRequestClosed(github, owner, repo, {
    pull_request: pullRequest
  })

  expect(removeLabels).not.toBeCalled()

  expect(github.issues.get).not.toBeCalled()

  expect(github.issues.edit).not.toBeCalled()
})
