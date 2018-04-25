const handlePullRequestClosed = require('./lib/handlePullRequestClosed')
const handlePullRequestOpened = require('./lib/handlePullRequestOpened')
const handleIssuesLabeled = require('./lib/handleIssuesLabeled')
const handlePullRequestReviewRequested = require('./lib/handlePullRequestReviewRequested')
const handlePullRequestReview = require('./lib/handlePullRequestReview')
const handleIssuesClosed = require('./lib/handleIssuesClosed')

module.exports = robot => {
  robot.on('issues.labeled', async context => {
    await handleIssuesLabeled(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.issue.number,
      context.payload.label.name
    )
  })

  robot.on('issues.closed', async context => {
    await handleIssuesClosed(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.issue
    )
  })

  robot.on('pull_request.closed', async context => {
    await handlePullRequestClosed(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.pull_request.body
    )
  })

  robot.on(
    ['pull_request.opened', 'pull_request.edited', 'pull_request.reopened'],
    async context => {
      await handlePullRequestOpened(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload.pull_request
      )
    }
  )

  robot.on('pull_request.review_requested', async context => {
    await handlePullRequestReviewRequested(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.pull_request.body
    )
  })

  robot.on('pull_request_review', async context => {
    await handlePullRequestReview(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.pull_request,
      context.payload.review
    )
  })
}
