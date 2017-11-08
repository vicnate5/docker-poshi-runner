#!/bin/bash

## This can be configured to run from one source directory at a time
## set the variable $source_dir to to path of your source files
##
## Run this script by using:
## ./docker_test.sh TESTNAME PORT
##
## Setting the port is optional, defaults to 8080

source_dir="$(pwd)"
echo $source_dir

OS=$(uname)

if [[ ${OS} == *Darwin* ]]
then
	open=open
	sed="sed -i '' -e"
	url="$(ifconfig en0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')"
elif [[ ${OS} == *Linux* ]]
then
	open=xdg-open
	sed="sed -i -e"
	url="$(ifconfig en0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')"
elif [[ ${OS} == *NT* ]]
then
	open=start
	sed="sed -i -e"
	url="$(ipconfig | grep IPv4 | cut -d: -f2 | awk '{ print $1}')"
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

if [[ -e ${source_dir}/test.root.properties ]]
then
	${sed} "s~test.url=.*~test.url=http://${url}:${port}~" ${source_dir}/test.root.properties
else
	echo "Unable to find test.root.properties file"
	echo 'Please create this file with property "test.url=" defined'
	exit
fi

docker run -t --rm -v ${source_dir}:/source:cached test-runner /bin/bash -c \
"/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class=${testname}"

echo
echo "Finished ${testname}"
prTestName=$(echo ${testname} | sed 's/#/_/')
${open} ${source_dir}/portal-web/test-results/${prTestName}/index.html
echo "done"