const handleSetup = require('../lib/handleSetup')
const {
  READY_FOR_REVIEW,
  REJECTED,
  REVIEW_REQUESTED,
  IN_PROGRESS
} = require('../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'

const github = {
  issues: {
    createLabel: jest.fn().mockReturnValue(Promise.resolve({}))
  }
}

const labels = {
  [READY_FOR_REVIEW]: 'fef2c0',
  [REJECTED]: 'e11d21',
  [REVIEW_REQUESTED]: 'fef2c0',
  [IN_PROGRESS]: 'fef2c0'
}

describe('handleSetup', () => {
  test('creates labels', async () => {
    await handleSetup(github, owner, repo, {})

    Object.keys(labels).forEach(async name => {
      expect(github.issues.createLabel).toBeCalledWith({
        owner,
        repo,
        name,
        color: labels[name]
      })
    })
  })
})
