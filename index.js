const findFixableIssues = require('./lib/findFixableIssues')
const { addLabels, removeLabels } = require('./lib/labels')
const handlePullRequestClosed = require('./lib/handlePullRequestClosed')
const handlePullRequestOpened = require('./lib/handlePullRequestOpened')
const {
  IN_PROGRESS,
  READY_FOR_REVIEW,
  REVIEW_REQUESTED,
  REJECTED
} = require('./lib/constants')

module.exports = robot => {
  robot.on('issues.labeled', async context => {
    switch (context.payload.label.name) {
      case READY_FOR_REVIEW:
        await removeLabels(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          context.payload.issue.number,
          [IN_PROGRESS]
        )
        break
      case REJECTED:
        await removeLabels(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          context.payload.issue.number,
          [IN_PROGRESS, READY_FOR_REVIEW]
        )
        break
      case REVIEW_REQUESTED:
        await removeLabels(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          context.payload.issue.number,
          [IN_PROGRESS]
        )
        await addLabels(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          context.payload.issue.number,
          [READY_FOR_REVIEW]
        )
        break
    }
  })

  robot.on('issues.closed', async context => {
    await removeLabels(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.issue.number,
      [IN_PROGRESS, READY_FOR_REVIEW, REVIEW_REQUESTED]
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
    await findFixableIssues(context.payload.pull_request.body).forEach(
      async number => {
        await addLabels(
          context.github,
          context.payload.repository.owner.login,
          context.payload.repository.name,
          number,
          [REVIEW_REQUESTED]
        )
      }
    )
  })

  robot.on('pull_request_review', async context => {
    switch (context.payload.review.state) {
      case 'changes_requested':
        await findFixableIssues(context.payload.pull_request.body).forEach(
          async number => {
            await addLabels(
              context.github,
              context.payload.repository.owner.login,
              context.payload.repository.name,
              number,
              [REJECTED]
            )
          }
        )
        break
      case 'approved':
        await findFixableIssues(context.payload.pull_request.body).forEach(
          async number => {
            await removeLabels(
              context.github,
              context.payload.repository.owner.login,
              context.payload.repository.name,
              number,
              [REVIEW_REQUESTED, REJECTED]
            )
          }
        )
        break
    }
  })
}
