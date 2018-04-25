const findFixableIssues = require('./findFixableIssues')
const { addLabels, removeLabels } = require('./labels')
const { REVIEW_REQUESTED, REJECTED } = require('./constants')

module.exports = async (github, owner, repo, pullRequest, review) => {
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
