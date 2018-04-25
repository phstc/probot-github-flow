const findFixableIssues = require('./findFixableIssues')
const { removeLabels } = require('./issues')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./constants')

const updateIssue = async (github, owner, repo, number, pullRequest) => {
  const issue = (await github.issues.get({ owner, repo, number })).data

  const body = issue.body
    .split(`**PR:** #${pullRequest.number}`)
    .join(`<strike>**PR:** #${pullRequest.number}</strike>`)

  await github.issues.edit({
    owner,
    repo,
    number,
    body,
    status: 'closed'
  })
}

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request

  if (!pullRequest.merged) {
    return
  }

  await findFixableIssues(pullRequest.body).forEach(async number => {
    await removeLabels(github, owner, repo, number, [
      IN_PROGRESS,
      READY_FOR_REVIEW,
      REVIEW_REQUESTED,
      REJECTED
    ])

    await updateIssue(github, owner, repo, number, pullRequest)
  })
}
