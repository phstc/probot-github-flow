const handleIssuesClosed = require('../../lib/handleIssuesClosed')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('../../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'
const issue = {
  number: '5678'
}
const github = {}

jest.mock('../../lib/utils/labels', () => ({
  removeLabels: jest.fn()
}))

const { removeLabels } = require('../../lib/utils/labels')

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
