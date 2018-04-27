const findFixableIssues = require('../../../lib/utils/findFixableIssues')

test('returns fixable issues', () => {
  expect(findFixableIssues('Closes #1234')).toEqual(['1234'])
  expect(
    findFixableIssues('Fix https://github.com/org/repo/issues/1234')
  ).toEqual(['1234'])
  expect(findFixableIssues('Resolve #1234 Fix #1234')).toEqual(['1234'])
  expect(findFixableIssues('Close #1234 \n Fixes #5678')).toEqual([
    '1234',
    '5678'
  ])
})

test('returns empty when no fixable issues', () => {
  expect(findFixableIssues('Hello World')).toEqual([])
})
