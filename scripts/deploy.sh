git diff-index --quiet HEAD -- || {
  echo >&2 "Repo has local changes! Please commit them before deploying."
  exit 1
}
npm test || {
  echo >&2 "Test failed, aborting."
  exit 1
}
coffee -co lib src
jitsu deploy -r patch || {
  echo >&2 "Deployment failed, aborting."
  exit 1
}
VERSION=`cat package.json | json -a version`
git add package.json
git commit -m $VERSION
exit 0 # ensures we exit with a code of 0, even if the commit doesn't do anything
