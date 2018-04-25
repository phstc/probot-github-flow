const { addLabels, removeLabels } = require('./lib/labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./lib/constants')

module.exports = async (github, owner, repo, number, addedLabelName) => {
  switch (addedLabelName) {
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
