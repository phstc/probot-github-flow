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

  if (issue.pull_request) {
    // skip pull requests
    return
  }

  const body = issue.body
    .split(`**PR:** #${pullRequest.number}`)
    .join(`<strike>**PR:** #${pullRequest.number}</strike>`)

  const attributes = { body }

  if (pullRequest.merged) {
    // attributes.state = 'closed'
  }

  // await github.issues.edit({
  //   ...attributes,
  //   owner,
  //   repo,
  //   number
  // })
}

const deleteBranch = async (github, owner, repo, pullRequest) => {
  try {
    await github.gitdata.deleteReference({
      owner,
      repo,
      ref: `heads/${pullRequest.head.ref}`
    })
  } catch (error) {
    // Ignore if branch no longer exists
  }
}

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request

  await deleteBranch(github, owner, repo, pullRequest)

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
