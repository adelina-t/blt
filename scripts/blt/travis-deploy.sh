#!/usr/bin/env bash

# This script performs a deployment for BLT itself via Travis CI.
cd $TRAVIS_BUILD_DIR/../blt-project

# N3_KEY and N3_SECRET are Travis CI environmental variables.
curl -o pipelines https://cloud.acquia.com/pipeline-client/download
chmod a+x pipelines
./pipelines configure --key=$N3_KEY --secret=$N3_SECRET

# Deploy to Acquia Cloud
blt deploy -Ddeploy.commitMsg="Automated commit to artifact by Travis CI for Build ${TRAVIS_BUILD_ID}" -Ddeploy.branch="8.x-build"
# Execute functional tests to assert that deployment artifact was created correctly.
phpunit tests/phpunit --group=deploy

# Update source repo, then execute Pipelines build.
git add -A
git remote add acquia bolt8@svn-5223.devcloud.hosting.acquia.com:bolt8.git
git commit -m "Automated commit to source by Travis CI for Build ${TRAVIS_BUILD_ID}". -n
git push acquia 8.x
./pipelines start
