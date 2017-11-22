#!/bin/bash

## Run poshi headlessly in Docker
##
## Run this script by using:
## ./docker_test.sh TESTNAME PORT
##
## Setting the port is optional, defaults to 8080

source_dir="$(pwd)"

OS=$(uname)

if [[ ${OS} == *Darwin* ]]
then
	open=open
	sed="sed -i '' -e"
	url="docker.for.mac.localhost"
elif [[ ${OS} == *Linux* ]]
then
	open=xdg-open
	sed="sed -i -e"
	url="$(ifconfig docker0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')"
elif [[ ${OS} == *NT* ]]
then
	open=start
	sed="sed -i -e"
	url="docker.for.win.localhost"
else
	echo "Could not detect OS"
	exit
fi

if [[ -z "${url}" ]]
then
	echo "Unable to get local IP"
	echo "Please check url statement for your OS in this script"
	exit
fi

if [[ ! -e ${source_dir}/build-test.xml ]]
then
	echo "Cannot find build-test.xml"
	echo "Please run this script from the root of your portal source directory"
	exit
fi

if [[ -z "${2}" ]]
then
	port="8080"
else
	port="${2}"
fi

testname="${1}"

echo
echo "${testname}"
echo "Portal url: ${url}:${port}"
echo

if [[ -e ${source_dir}/test.root.properties ]]
then
	${sed} "s/test.url=.*/test.url=http:\/\/${url}:${port}/" ${source_dir}/test.root.properties
else
	echo "test.root.properties file not found"
	echo "test.url=http://${url}:${port}" > ${source_dir}/test.root.properties
	(echo ""; echo "test.skip.tear.down=true") >> ${source_dir}/test.root.properties
	(echo ""; echo "test.assert.console.errors=false") >> ${source_dir}/test.root.properties
	echo "test.root.properties created"
fi

docker run -t --rm -v ${source_dir}:/source:cached vicnate5/functional-test-runner /bin/bash -c \
"/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class=${testname}"

echo
echo "Finished ${testname}"
prTestName=$(echo ${testname} | sed 's/#/_/')
${open} ${source_dir}/portal-web/test-results/${prTestName}/index.html
echo "done"