const { removeLabels } = require('./lib/labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED
} = require('./lib/constants')

module.exports = async (github, owner, repo, issue) => {
  await removeLabels(github, owner, repo, issue.number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED
  ])
}
