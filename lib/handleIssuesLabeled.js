const { addLabels, removeLabels } = require('./utils/labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./utils/constants')

module.exports = async (github, owner, repo, payload) => {
  if (payload.issue.pull_request) {
    // skip pull requests
    return
  }
  const { number } = payload.issue
  const { name } = payload.label

  switch (name) {
    case READY_FOR_REVIEW:
      await removeLabels(github, owner, repo, number, [IN_PROGRESS])
      break
    case REJECTED:
      await removeLabels(github, owner, repo, number, [
        IN_PROGRESS,
        READY_FOR_REVIEW
      ])
      break
    case REVIEW_REQUESTED:
      await removeLabels(github, owner, repo, number, [IN_PROGRESS])
      await addLabels(github, owner, repo, number, [READY_FOR_REVIEW])
      break
  }
}
