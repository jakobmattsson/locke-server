### Features (from a testing perspective)

* 01. Authenticating a user (createUser, authPassword, authToken)
* 02. jsonp
* 03. Graceful handling of invalid functions (404)
* 04. Creating apps (createApp, getApps)
* 05. Closing sessions (closeSession, closeAllSessions)
* 06. Deleting a user (deleteUser)
* 07. Updating password (updatePassword)
* 08. Deleting apps (deleteApp)
* 09. Forgot password (sendPasswordReset, resetPassword)
* 10. Validating user (sendValidation, validateUser)



### Basic functions - getting started

createUser(app, email, password)
  - { status: "Could not find an app with that name" }
  - { status: "The given email is already in use for this app" }
  - { status: "Password too short - use at least 6 characters" }
  - { status: "Password too common - use something more unique" }
  - { status: "OK" } A new user has been created for the given app

authPassword(app, email, password, secondsToLive)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect password" }
  - { status: "The parameter 'secondsToLive' must be an integer >0" }
  - { status: "OK", token: ".......", validated: false }

authToken(app, email, token)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect token" }
  - { status: "Token timed out" }
  - { status: "OK", validated: false }



### Getting further - deleting, closing and updating

deleteUser(app, email, password)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect password" }
  - { status: "OK" }

closeSession(app, email, token)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect token" }
  - { status: "OK" }

closeAllSessions(app, email, password)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect password" }
  - { status: "OK" }

updatePassword(app, email, oldPassword, newPassword)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect password" }
  - { status: "Password too short - use at least 6 characters" }
  - { status: "Password too common - use something more unique" }
  - { status: "OK" }



### Email validation and resetting password; the emailing functions

sendValidation(app, email)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "The user has already been validated" }
  - { status: "OK" }

sendPasswordReset(app, email)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "OK" }

resetPassword(app, email, resetToken, newPassword)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "Incorrect token" }
  - { status: "Password too short - use at least 6 characters" }
  - { status: "Password too common - use something more unique" }
  - { status: "OK" }

validateUser(app, email, validationToken)
  - { status: "Could not find an app with that name" }
  - { status: "There is no user with that email for the given app" }
  - { status: "The user has already been validated" }
  - { status: "Incorrect token" }
  - { status: "OK" }



### Managing apps - for app developers only

createApp(email, token, app)
  - { status: "There is no user with that email for the locke-app" }
  - { status: "Incorrect token" }
  - { status: "App name is already is use" }
  - { status: "OK" }

getApps(email, token)
  - { status: "There is no user with that email for the locke-app" }
  - { status: "Incorrect token" }
  - { status: "OK", apps: { app1: { userCount: x }, app2: { userCount: y } } }

deleteApp(email, password, app)
  - { status: "There is no user with that email for the locke-app" }
  - { status: "Incorrect password" }
  - { status: "Could not find an app with that name" }
  - { status: "OK" }



### Invariants exposed by the interface

- Ensure the parameter 'secondsToLive' for 'authPassword' times out on time
- Ensure calling 'authToken' reset the timeout for the token to the time specified when it was created using 'authPassword'
- Ensure no duplicate tokens are ever generated
- Ensure 'updatePassword' and 'resetPassword' invalidates all passwordReset tokens for the given user
- Ensure 'updatePassword' and 'resetPassword' does not invalid tokens for user validation and authentication
- Ensure emails are actually sent by 'sendValidation' and 'sendPasswordReset'
- Ensure that only the latest password will work for the password-protected functions (authPassword, deleteUser, updatePassword)



### Internal invariants

- Ensure 'closeSession' and 'closeSessions' deletes the tokens from the backend permanently
- Ensure 'deleteUser' deletes the given user from the backend permanently
- Ensure 'updatePassword' deletes the old password from the backend permanently



### Invariants I don't know how to test

- Ensure the token generated (by all token generating functions; 'authPassword', 'sendValidation', 'sendPasswordReset') are unpredictable (high entropy etc)



### Ideas for the future

* Throttling of different kinds
* Captchas for breaking throttling - maybe?


### Disclaimer

Evil developers will still be able to scam stupid users. Not more than they are already doing though.

On the other hand, developers with good intentions will be less likely to screw up. And the amount of wheel they have to reinvent will be minimal.
