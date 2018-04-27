const { removeLabels } = require('./utils/labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('./utils/constants')

module.exports = async (github, owner, repo, payload) => {
  await removeLabels(github, owner, repo, payload.issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED
  ])
}
