const handleRepositoryVunerabilityAlertCreate = require('../lib/handleRepositoryVunerabilityAlertCreate')
const { SECURITY } = require('../lib/utils/constants')

const owner = 'owner'
const repo = 'repo'
const alert = {
  affected_package_name: 'foo',
  affected_range: '1.0.0'
}
const github = {
  issues: {
    create: jest.fn()
  }
}

test('files issue', async () => {
  await handleRepositoryVunerabilityAlertCreate(github, owner, repo, { alert })

  const title = `Security vulnerability found in ${alert.affected_package_name}`

  const body = `- Affected version ${alert.affected_package_name} ${
    alert.affected_range
  } \n- Fixed in ${alert.fixed_in}`

  expect(github.issues.create).toBeCalledWith({
    owner,
    repo,
    title,
    body,
    labels: [SECURITY]
  })
})
