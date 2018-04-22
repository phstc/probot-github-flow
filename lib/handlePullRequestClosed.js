const findFixableIssues = require('./findFixableIssues')
const { removeLabels } = require('./labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./constants')

const closeIssue = async (github, owner, repo, number) => {
  github.issues.edit({ owner, repo, number, state: 'closed' })

  await removeLabels(github, owner, repo, number, [
    IN_PROGRESS,
    READY_FOR_REVIEW,
    REVIEW_REQUESTED,
    REJECTED
  ])
}
const updateIssue = async (github, owner, repo, number) => {
  // issue = client.issue(repo_full_name, number)
  // def remove_pr_reference(issue)
  //   body = issue['body'].to_s
  //   body.gsub("**PR:** ##{pr_number}", "<strike>**PR:** ##{pr_number}</strike>")
  // end
  // client.update_issue(repo_full_name, number, issue['title'], body)
}
module.exports = async (github, owner, repo, pullRequest) => {
  findFixableIssues(pullRequest.body).forEach(async number => {
    if (pullRequest.merged) {
      closeIssue(github, owner, repo, number)
      updateIssue(github, owner, repo, number)
    }
  })
}
