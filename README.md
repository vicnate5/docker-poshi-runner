# docker-poshi-runner
Run poshi tests using docker

### Setup
1. Install Docker [Windows](https://docs.docker.com/windows)/[Mac](https://docs.docker.com/mac)/[Linux](https://docs.docker.com/linux)
2. Clone this repo
3. Open Terminal (or Docker Quickstart Terminal if you are on Windows)
4. `cd` _docker-poshi-runner directory_
5. `docker build -t test-runner .`
6. Make a copy of your `test.{username}.properties` named `test.root.properties` in your portal source directory
	* Make sure this file has the `test.url` property set

### Run test with script

1. Edit `run_test.sh` and set path for `source_dir`
2. From Terminal: `./run_test.sh {testname} {port)`

Note for Mac users: the script uses `gsed`

### Run test manually
1. Edit `test.url` property in `test.root.properties`
    * Get IP of machine that is running the portal
    * Add property value `test.url=http://{IP}:8080`
2. Run the test 
`docker run -t --rm -v {source_dir_path}:/source test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class={testname}"`
3. Results will be stored in the normal location as the docker container simply mounts your source folder
    * `{source_dir_path}/portal-web/test-results/`