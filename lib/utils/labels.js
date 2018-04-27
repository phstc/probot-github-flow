const addLabels = async (github, owner, repo, number, labels) => {
  await github.issues.addLabels({ owner, repo, number, labels })
}

const removeLabels = async (github, owner, repo, number, labels) => {
  labels.forEach(async name => {
    await github.issues.removeLabel({
      owner,
      repo,
      number,
      name
    })
  })
}

module.exports = {
  addLabels,
  removeLabels
}
