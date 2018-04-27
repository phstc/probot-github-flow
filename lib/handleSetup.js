const {
  READY_FOR_REVIEW,
  REJECTED,
  REVIEW_REQUESTED,
  IN_PROGRESS
} = require('./constants')

module.exports = async (github, payload) => {
  const labels = {
    READY_FOR_REVIEW: 'fef2c0',
    REJECTED: 'e11d21',
    REVIEW_REQUESTED: 'fef2c0',
    IN_PROGRESS: 'fef2c0'
  }

  const repos = await github.apps.getInstallationRepositories()
  repos.forEach(async repository => {
    const owner = repository.owner.login
    const repo = repository.name
    Object.keys(labels).forEach(async name => {
      await github.issues.createLabel({
        owner,
        repo,
        name,
        color: labels[name]
      })
    })
  })
}
