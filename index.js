const rollbar = require('rollbar')
const handlePullRequestClosed = require('./lib/handlePullRequestClosed')
const handlePullRequestOpened = require('./lib/handlePullRequestOpened')
const handleIssuesLabeled = require('./lib/handleIssuesLabeled')
const handlePullRequestReviewRequested = require('./lib/handlePullRequestReviewRequested')
const handlePullRequestReview = require('./lib/handlePullRequestReview')
const handleIssuesClosed = require('./lib/handleIssuesClosed')
const handleInstallation = require('./lib/handleInstallation')

if (process.env.NODE_ENV === 'production') {
  rollbar.init(process.env.ROLLBAR_ACCESS_TOKEN)
}

const handleError = e => {
  if (process.env.NODE_ENV === 'production') {
    rollbar.handleError(e)
  }
}

module.exports = robot => {
  robot.on('issues.labeled', async context => {
    try {
      await handleIssuesLabeled(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    } catch (e) {
      handleError(e)
    }
  })

  robot.on('issues.closed', async context => {
    try {
      await handleIssuesClosed(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload.issue
      )
    } catch (e) {
      handleError(e)
    }
  })

  robot.on('pull_request.closed', async context => {
    try {
      await handlePullRequestClosed(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    } catch (e) {
      handleError(e)
    }
  })

  robot.on(
    ['pull_request.opened', 'pull_request.edited', 'pull_request.reopened'],
    async context => {
      try {
        await handlePullRequestOpened(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          context.payload
        )
      } catch (e) {
        handleError(e)
      }
    }
  )

  robot.on('pull_request.review_requested', async context => {
    try {
      await handlePullRequestReviewRequested(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    } catch (e) {
      handleError(e)
    }
  })

  robot.on('pull_request_review', async context => {
    try {
      await handlePullRequestReview(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    } catch (e) {
      handleError(e)
    }
  })

  robot.on('installation.created', async context => {
    try {
      // await handleInstallation(context.github, context.payload)
    } catch (e) {
      handleError(e)
    }
  })
}
