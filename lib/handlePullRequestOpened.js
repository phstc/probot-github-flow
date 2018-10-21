const findFixableIssues = require('./utils/findFixableIssues')
const { addLabels } = require('./utils/labels')
const { IN_PROGRESS, READY_FOR_REVIEW } = require('./utils/constants')

const setInProgress = async (github, owner, repo, issue) => {
  if (issue.labels.some(label => label.name === READY_FOR_REVIEW)) {
    return
  }

  addLabels(github, owner, repo, issue.number, [IN_PROGRESS])
}

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request

  await findFixableIssues(pullRequest.body).forEach(async number => {
    const issue = (await github.issues.get({ owner, repo, number })).data

    if (issue.pull_request) {
      // skip pull requests
      return
    }

    if (issue.state === 'closed') {
      return
    }

    await github.issues.addAssigneesToIssue({
      owner,
      repo,
      number,
      assignees: [pullRequest.user.login]
    })

    await setInProgress(github, owner, repo, issue)
  })
}
