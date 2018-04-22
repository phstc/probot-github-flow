const findFixableIssues = require('./findFixableIssues')
const { removeLabels } = require('./labels')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./constants')

module.exports = async (github, owner, repo, pullRequest) => {
  findFixableIssues(pullRequest.body).forEach(async number => {
    if (pullRequest.merged) {
      await removeLabels(github, owner, repo, number, [
        IN_PROGRESS,
        READY_FOR_REVIEW,
        REVIEW_REQUESTED,
        REJECTED
      ])

      const issue = await client.issues.get({ owner, repo, number })

      // body.gsub("**PR:** ##{pr_number}", "<strike>**PR:** ##{pr_number}</strike>")
      const body = issue.body.replace(
        `**PR:** #${pullRequest.number}`,
        `<strike>**PR:** #${pr_number}</strike>`
      )

      await github.issues.edit({ owner, repo, number, body, status: 'closed' })
    }
  })
}
