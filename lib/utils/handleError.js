const rollbar = require('rollbar')

const isRollbarEnabled = () =>
  process.env.ROLLBAR_ACCESS_TOKEN && process.env.ROLLBAR_ACCESS_TOKEN !== ''

if (isRollbarEnabled()) {
  rollbar.init(process.env.ROLLBAR_ACCESS_TOKEN)
}

module.exports = async error => {
  if (isRollbarEnabled()) {
    rollbar.handleError(error)
  }
}
