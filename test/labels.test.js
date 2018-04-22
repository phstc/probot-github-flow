const { addLabels, removeLabels } = require('../lib/labels')

const github = {
  issues: {
    addLabels: jest.fn(),
    removeLabel: jest.fn()
  }
}
const owner = 'owner'
const repo = 'repo'
const number = '1234'
const labels = ['label1', 'label2']

test('adds labels', async () => {
  addLabels(github, owner, repo, number, labels)

  expect(github.issues.addLabels).toBeCalledWith({
    owner,
    repo,
    number,
    labels
  })
})

test('removes labels', async () => {
  removeLabels(github, owner, repo, number, labels)

  labels.forEach(name => {
    expect(github.issues.removeLabel).toBeCalledWith({
      owner,
      repo,
      number,
      name
    })
  })
})
