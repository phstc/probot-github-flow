// Supports
// Closes #issue-number
// Closes https://github.com/org/repo/issues/issue-number
// Closes org/repo/issues/issue-number
module.exports = body => {
  const matches = body.match(
    /(close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\s*(#\d+|https?\:\/\/github\.com\/.*\/.*\/issues\/\d+|.*\/.*#\d+)/gi
  )

  return Array.from(
    new Set(
      (matches || []).map(match => {
        if (match.indexOf('#') > -1) {
          // #1234
          return match.split('#').pop()
        } else {
          // https://github.com/org/repo/issues/1234
          return match.split('/').pop()
        }
      })
    )
  )
}
