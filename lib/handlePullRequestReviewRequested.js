const findFixableIssues = require('./utils/findFixableIssues')
const { addLabels } = require('./utils/labels')
const { REVIEW_REQUESTED } = require('./utils/constants')

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request
  await findFixableIssues(pullRequest.body).forEach(async number => {
    await addLabels(github, owner, repo, number, [REVIEW_REQUESTED])
  })
}
