const rollbar = require('rollbar')
const handlePullRequestClosed = require('./lib/handlePullRequestClosed')
const handlePullRequestOpened = require('./lib/handlePullRequestOpened')
const handleIssuesLabeled = require('./lib/handleIssuesLabeled')
const handlePullRequestReviewRequested = require('./lib/handlePullRequestReviewRequested')
const handlePullRequestReview = require('./lib/handlePullRequestReview')
const handleIssuesClosed = require('./lib/handleIssuesClosed')
const handleSetup = require('./lib/handleSetup')

const isProduction = () => process.env.NODE_ENV === 'production'

if (isProduction()) {
  rollbar.init(process.env.ROLLBAR_ACCESS_TOKEN)
}

const wrapHandler = async (handler, context) => {
  try {
    const handlers = [handleSetup, targetHandler]
    handlers.forEach(async handler => {
      await handler(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    })
  } catch (error) {
    robot.log.error(error)
    handleError(error)
  }
}

const handleError = e => {
  if (isProduction()) {
    rollbar.handleError(e)
  }
}

module.exports = robot => {
  robot.on('issues.labeled', async context => {
    await wrapHandler(handleIssuesLabeled, context)
  })

  robot.on('issues.closed', async context => {
    await wrapHandler(handleIssuesClosed, context)
  })

  robot.on('pull_request.closed', async context => {
    await wrapHandler(handlePullRequestClosed, context)
  })

  robot.on(
    ['pull_request.opened', 'pull_request.edited', 'pull_request.reopened'],
    async context => {
      await wrapHandler(handlePullRequestOpened, context)
    }
  )

  robot.on('pull_request.review_requested', async context => {
    await wrapHandler(handlePullRequestReviewRequested, context)
  })

  robot.on('pull_request_review', async context => {
    await wrapHandler(handlePullRequestReview, context)
  })
}
