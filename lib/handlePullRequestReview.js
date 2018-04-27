const findFixableIssues = require('./utils/findFixableIssues')
const { addLabels, removeLabels } = require('./utils/labels')
const { REVIEW_REQUESTED, REJECTED } = require('./utils/constants')

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request
  const { review } = payload

  switch (review.state) {
    case 'changes_requested':
      await findFixableIssues(pullRequest.body).forEach(async number => {
        await addLabels(github, owner, repo, number, [REJECTED])
      })
      break
    case 'approved':
      await findFixableIssues(pullRequest.body).forEach(async number => {
        await removeLabels(github, owner, repo, number, [
          REVIEW_REQUESTED,
          REJECTED
        ])
      })
      break
  }
}
