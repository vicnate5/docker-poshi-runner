# docker-poshi-runner
Run poshi tests using docker

### Setup
1. Install Docker [Windows](https://docs.docker.com/windows)/[Mac](https://docs.docker.com/mac)/[Linux](https://docs.docker.com/linux)
2. Set docker virtual machine memory to at least 2gb (4gb recommended)
3. Clone this repo (or just download the run_test.sh file)

### Running a test with script

1. Start a local Portal server
2. From the root directory of your Portal source code, run the script:
```
./run_test.sh {testname}
```

### Run test manually
1. Start a local Portal server
2. Create a file in your Portal source directory called `test.root.properties`
2. Add `test.url` property to `test.root.properties`
    * Get IP of machine that is running the portal
    * Add property value `test.url=http://{IP}:8080`
3. Run the test
```
docker run -t --rm -v ${source_dir}:/source:cached vicnate5/functional-test-runner /bin/bash -c \
"/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class={testname}"
```

Note: Results will be stored in the normal location as the docker container simply mounts your source folder
* `{source_dir_path}/portal-web/test-results/`
