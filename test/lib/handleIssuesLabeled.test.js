const handleIssuesLabeled = require('../../lib/handleIssuesLabeled')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('../../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'
const issue = {
  number: '5678'
}
const github = {}

jest.mock('../../lib/utils/labels', () => ({
  removeLabels: jest.fn(),
  addLabels: jest.fn()
}))

const { addLabels, removeLabels } = require('../../lib/utils/labels')

beforeEach(() => {
  removeLabels.mockReset()
  addLabels.mockReset()
})

test('labeled with READY_FOR_REVIEW', async () => {
  await handleIssuesLabeled(github, owner, repo, {
    issue,
    label: { name: READY_FOR_REVIEW }
  })

  expect(removeLabels).toBeCalledWith(github, owner, repo, issue.number, [
    IN_PROGRESS
  ])
})

test('labeled with REJECTED', async () => {
  await handleIssuesLabeled(github, owner, repo, {
    issue,
    label: { name: REJECTED }
  })

  expect(removeLabels).toBeCalledWith(github, owner, repo, issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW
  ])
})

test('labeled with REVIEW_REQUESTED', async () => {
  await handleIssuesLabeled(github, owner, repo, {
    issue,
    label: { name: REVIEW_REQUESTED }
  })

  expect(removeLabels).toBeCalledWith(github, owner, repo, issue.number, [
    IN_PROGRESS
  ])

  expect(addLabels).toBeCalledWith(github, owner, repo, issue.number, [
    READY_FOR_REVIEW
  ])
})
