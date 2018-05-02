const findFixableIssues = require('./utils/findFixableIssues')
const { addLabels } = require('./utils/labels')
const { IN_PROGRESS, READY_FOR_REVIEW } = require('./utils/constants')

const setInProgress = async (github, owner, repo, issue) => {
  if (issue.labels.some(label => label.name === READY_FOR_REVIEW)) {
    return
  }

  addLabels(github, owner, repo, issue.number, [IN_PROGRESS])
}

const addPullRequestReference = async (
  github,
  owner,
  repo,
  issue,
  pullRequestNumber
) => {
  let body = issue.body
    .split(`<strike>**PR:** #${pullRequestNumber}</strike>`)
    .join(`**PR:** #${pullRequestNumber}`)

  if (body.indexOf(`**PR:** #${pullRequestNumber}`) !== -1) {
    return
  }

  if (body.indexOf('**PR:**') === -1) {
    body += '\n\n'
  }

  body += `\n**PR:** #${pullRequestNumber}`

  await github.issues.edit({
    owner,
    repo,
    number: issue.number,
    body
  })
}

module.exports = async (github, owner, repo, payload) => {
  const pullRequest = payload.pull_request

  await findFixableIssues(pullRequest.body).forEach(async number => {
    const issue = (await github.issues.get({ owner, repo, number })).data

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

    await addPullRequestReference(
      github,
      owner,
      repo,
      issue,
      pullRequest.number
    )
  })
}
