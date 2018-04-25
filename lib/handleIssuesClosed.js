const { removeLabels } = require('./issues')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('./constants')

module.exports = async (github, owner, repo, payload) => {
  await removeLabels(github, owner, repo, payload.issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED
  ])
}
