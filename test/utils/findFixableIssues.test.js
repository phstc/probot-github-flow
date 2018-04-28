const findFixableIssues = require('../../lib/utils/findFixableIssues')

test('returns issues', () => {
  expect(findFixableIssues('Closes #1234')).toEqual(['1234'])
  expect(
    findFixableIssues('Fix https://github.com/org/repo/issues/1234')
  ).toEqual(['1234'])
  expect(findFixableIssues('Resolve #1234 Fix #1234')).toEqual(['1234'])
  expect(findFixableIssues('Close #1234 \n Fixes #5678')).toEqual([
    '1234',
    '5678'
  ])
  expect(findFixableIssues('Closes username/repository#1234')).toEqual(['1234'])
})

test('returns no issues', () => {
  expect(findFixableIssues('Hello World')).toEqual([])
})
