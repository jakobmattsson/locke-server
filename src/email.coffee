email = require 'emailjs'

exports.setup = (settings) ->
  server = email.server.connect
    user: settings.user
    password: settings.password
    host: settings.host
    ssl: true

  send: (to, data, callback) ->

    keys = {
      reset: 'reset'
      validation: 'validate'
    }

    content = "https://lockeapp.herokuapp.com/#/#{keys[data.type]}/#{data.app}/#{to}/#{data.token}"

    message =
      from: "Support <support@lockeapp.com>"
      text: content
      to: to
      subject: "Account information"

    server.send message, (err, message) ->
      console.log(new Date(), err, message)
      callback err

# Testa så att mailet kommit fram med: https://github.com/mscdex/node-imap
# kommer behöva kryptera inloggningsuppgifterna till avsändare och mottagare av mailet: http://about.travis-ci.org/docs/user/encryption-keys
