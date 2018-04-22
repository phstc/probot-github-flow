const findFixableIssues = require('./lib/findFixableIssues')
const { addLabels, removeLabels } = require('./lib/labels')

const READY_FOR_REVIEW = 'ready for review'
const REJECTED = 'rejected'
const REVIEW_REQUESTED = 'review requested'
const IN_PROGRESS = 'in progress'

module.exports = robot => {
  robot.on('issues.labeled', async context => {
    robot.log(context)

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
    robot.log(context)

    await removeLabels(
      context.github,
      context.payload.repository.owner.login,
      context.payload.repository.name,
      context.payload.issue.number,
      [IN_PROGRESS, READY_FOR_REVIEW, REVIEW_REQUESTED]
    )
  })

  robot.on('pull_request.closed', async context => {
    robot.log(context)
  })

  robot.on(
    ['pull_request.opened', 'pull_request.edited', 'pull_request.reopened'],
    async context => {
      robot.log(context)
    }
  )

  robot.on('pull_request.review_requested', async context => {
    robot.log(context)

    findFixableIssues(context.payload.pull_request.body).forEach(
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
    robot.log(context)

    switch (context.payload.review.state) {
      case 'changes_requested':
        findFixableIssues(context.payload.pull_request.body).forEach(
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
        findFixableIssues(context.payload.pull_request.body).forEach(
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
