#!/bin/bash

## This can be configured to run from one source directory at a time
## set the variable $source_dir to to path of your source files
##
## Run this script by using:
## ./docker_test.sh TESTNAME PORT
##
## Setting the port is optional, defaults to 8080

source_dir="/Users/vicnate5/Liferay/liferay-portal-master/"

OS=$(uname)

if [[ ${OS} == *Darwin* ]]
then
	open=open
	sed="sed -i '' -e"
	url="$(ifconfig en4 | grep 'inet 192' | cut -d: -f2 | awk '{ print $2}')"
elif [[ ${OS} == *Linux* ]]
then
	open=xdg-open
	sed="sed -i -e"
	url="$(ifconfig en4 | grep 'inet 192' | cut -d: -f2 | awk '{ print $2}')"
elif [[ ${OS} == *NT* ]]
then
	open=start
	sed="sed -i -e"
	url="$(ipconfig | grep IPv4 | cut -d: -f2 | awk '{ print $1}')"
else
	echo "Could not detect OS"
	exit
fi


if [[ -z "${2}" ]]
then
	port="8080"
else
	port="${2}"
fi

testname="${1}"

echo "${testname}"
echo "Portal url: ${url}:${port}"
echo

${sed} "s~test.url=.*~test.url=http://${url}:${port}~" ${source_dir}/test.root.properties

docker run -t --rm -v ${source_dir}:/source test-runner /bin/bash -c \
"/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class=${testname}"

echo
echo "Finished ${testname}"
prTestName=$(echo ${testname} | sed 's/#/_/')
${open} ${source_dir}/portal-web/test-results/${prTestName}/index.html
echo "done"