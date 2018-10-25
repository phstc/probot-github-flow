const handlePullRequestClosed = require('./lib/handlePullRequestClosed')
const handlePullRequestOpened = require('./lib/handlePullRequestOpened')
const handleIssuesLabeled = require('./lib/handleIssuesLabeled')
const handlePullRequestReviewRequested = require('./lib/handlePullRequestReviewRequested')
const handlePullRequestReview = require('./lib/handlePullRequestReview')
const handleIssuesClosed = require('./lib/handleIssuesClosed')
// const handleSetup = require('./lib/handleSetup')
const handleError = require('./lib/utils/handleError')

const wrapHandler = async (robot, targetHandler, context) => {
  try {
    // const handlers = [handleSetup, targetHandler]
    const handlers = [targetHandler]
    handlers.forEach(async handler => {
      await handler(
        context.github,
        context.payload.repository.owner.login,
        context.payload.repository.name,
        context.payload
      )
    })
  } catch (error) {
    handleError(error)
    throw error
  }
}

module.exports = robot => {
  robot.on('installation.created', async context => {
    // TODO review this, it is not working:
    // ERROR probot: {"message":"Resource not accessible by integration","documentation_url":"https://developer.github.com/v3/issues/labels/#create-a-label"}
    // const owner = context.payload.installation.account.login
    //
    // context.payload.repositories.forEach(async (repo: any) => {
    //   await handleSetup(context.github, owner, repo.name, context.payload)
    // })
  })

  robot.on('issues.labeled', async context => {
    await wrapHandler(robot, handleIssuesLabeled, context)
  })

  robot.on('issues.closed', async context => {
    await wrapHandler(robot, handleIssuesClosed, context)
  })

  robot.on('pull_request.closed', async context => {
    await wrapHandler(robot, handlePullRequestClosed, context)
  })

  robot.on(
    ['pull_request.opened', 'pull_request.edited', 'pull_request.reopened'],
    async context => {
      await wrapHandler(robot, handlePullRequestOpened, context)
    }
  )

  robot.on('pull_request.review_requested', async context => {
    await wrapHandler(robot, handlePullRequestReviewRequested, context)
  })

  robot.on('pull_request_review', async context => {
    await wrapHandler(robot, handlePullRequestReview, context)
  })
}
