const findFixableIssues = require('./utils/findFixableIssues')
const { removeLabels } = require('./utils/labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./utils/constants')

const updateIssue = async (github, owner, repo, number, pullRequest) => {
  const issue = (await github.issues.get({ owner, repo, number })).data

  const body = issue.body
    .split(`**PR:** #${pullRequest.number}`)
    .join(`<strike>**PR:** #${pullRequest.number}</strike>`)

  const attributes = { body }

  if (pullRequest.merged) {
    attributes.state = 'closed'
  }

  await github.issues.edit({
    ...attributes,
    owner,
    repo,
    number
  })
}

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request

  await findFixableIssues(pullRequest.body).forEach(async number => {
    if (pullRequest.merged) {
      await removeLabels(github, owner, repo, number, [
        IN_PROGRESS,
        READY_FOR_REVIEW,
        REVIEW_REQUESTED,
        REJECTED
      ])
    }

    await updateIssue(github, owner, repo, number, pullRequest)
  })
}
