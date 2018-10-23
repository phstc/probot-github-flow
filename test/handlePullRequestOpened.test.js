const handlePullRequestOpened = require('../lib/handlePullRequestOpened')
const { READY_FOR_REVIEW } = require('../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'
const number = '1234'
const pullRequest = {
  body: `Closes #${number}`,
  merged: true,
  number: '5678',
  user: {
    login: 'phstc'
  }
}

const github = {
  issues: {
    get: jest.fn(),
    edit: jest.fn(),
    addAssigneesToIssue: jest.fn()
  }
}

jest.mock('../lib/utils/labels', () => ({
  addLabels: jest.fn()
}))

const { addLabels } = require('../lib/utils/labels')

beforeEach(() => {
  addLabels.mockReset()
  github.issues.get.mockReset()
  github.issues.edit.mockReset()
  github.issues.addAssigneesToIssue.mockReset()
})

test('skips closed issues', async () => {
  const issue = { number: '1234', state: 'closed' }
  github.issues.get.mockReturnValue(issue)

  await handlePullRequestOpened(github, owner, repo, {
    pull_request: pullRequest
  })

  expect(github.issues.get).toBeCalledWith({ owner, repo, number })
  expect(github.issues.addAssigneesToIssue).not.toBeCalled()
  expect(addLabels).not.toBeCalled()
})

test('skips labeling with IN_PROGRESS', async () => {
  const issue = {
    number: '1234',
    state: 'open',
    body: '',
    labels: [{ name: READY_FOR_REVIEW }]
  }
  github.issues.get.mockReturnValue({ data: issue })

  await handlePullRequestOpened(github, owner, repo, {
    pull_request: pullRequest
  })

  expect(github.issues.get).toBeCalledWith({ owner, repo, number })
  expect(github.issues.addAssigneesToIssue).toBeCalledWith({
    owner,
    repo,
    number,
    assignees: [pullRequest.user.login]
  })
  expect(addLabels).not.toBeCalled()
})
