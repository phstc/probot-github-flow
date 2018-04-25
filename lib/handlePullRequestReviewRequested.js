const findFixableIssues = require('./findFixableIssues')
const { addLabels } = require('./labels')
const { REVIEW_REQUESTED } = require('./constants')

module.exports = async (github, owner, repo, body) => {
  await findFixableIssues(body).forEach(async number => {
    await addLabels(github, owner, repo, number, [REVIEW_REQUESTED])
  })
}
