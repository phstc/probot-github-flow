const { SECURITY } = require('./utils/constants')

module.exports = async (github, owner, repo, payload) => {
  const alert = payload.alert
  const title = `Security vulnerability found in ${alert.affected_package_name}`

  const body = `- Affected version ${alert.affected_package_name} ${
    alert.affected_range
  } \n- Fixed in ${alert.fixed_in}`

  await github.issues.create({
    owner,
    repo,
    title,
    body,
    labels: [SECURITY]
  })
}
