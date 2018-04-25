const handleIssuesClosed = require('../lib/handleIssuesClosed')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('../lib/constants')

const owner = 'owner'
const repo = 'repo'
const issue = {
  number: '5678'
}
const github = {}

jest.mock('../lib/issues', () => ({
  removeLabels: jest.fn()
}))

const { removeLabels } = require('../lib/issues')

beforeEach(() => {
  removeLabels.mockReset()
})

test('remove labels', async () => {
  await handleIssuesClosed(github, owner, repo, { issue })

  expect(removeLabels).toBeCalledWith(github, owner, repo, issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED
  ])
})
