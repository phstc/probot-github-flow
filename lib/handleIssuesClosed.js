const { removeLabels } = require('./lib/issues')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('./lib/constants')

module.exports = async (github, owner, repo, payload) => {
  await removeLabels(github, owner, repo, payload.issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED
  ])
}
