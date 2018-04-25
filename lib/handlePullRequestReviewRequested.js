const findFixableIssues = require('./findFixableIssues')
const { addLabels } = require('./issues')
const { REVIEW_REQUESTED } = require('./constants')

module.exports = async (github, owner, repo, payload) => {
  const { pullRequest } = payload
  await findFixableIssues(pullRequest.body).forEach(async number => {
    await addLabels(github, owner, repo, number, [REVIEW_REQUESTED])
  })
}
