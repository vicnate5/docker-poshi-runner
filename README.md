# docker-poshi-runner
Run poshi tests headlessly using docker.

### Setup
1. Install Docker [Windows](https://docs.docker.com/windows)/[Mac](https://docs.docker.com/mac)/[Linux](https://docs.docker.com/linux)
2. Set docker virtual machine memory to at least 2gb (4gb recommended)
3. Clone this repo (or just download the **run_test.sh** script file)

A built image is hosted at https://hub.docker.com/r/vicnate5/functional-test-runner/ so you do not need to build the Dockerfile unless you want to make changes to it.

### Running a test with the script (Mac/Linux only)

1. Start a local Portal server
2. From the root directory of your Portal source code, copy over and run the script:
```
./run_test.sh {testname}
```
e.g.
```
./run_test.sh PortalSmoke#Smoke
```

### Run test manually
1. Start a local Portal server
2. Create a file in your Portal source directory named `test.root.properties`
3. Add `test.url` property to `test.root.properties`
    * Get IP of machine that is running the portal
    * Add property value `test.url=http://{IP}:8080`<br /><br />
*Additional Recommended Properties:*<br />
`test.skip.tear.down=true`<br />
`test.assert.console.errors=false`
4. From the root directory of your Portal source code, run the following command:

Windows (use windows command line, will not work in gitbash)
```
docker run -t --rm -v %cd%:/source vicnate5/functional-test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class={testname}"
```

Mac/Linux
```
docker run -t --rm -v $(pwd):/source:cached vicnate5/functional-test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.class={testname}"
```


Note: Results will be stored in the normal location as the docker container simply mounts your source folder
* `{source_dir_path}/portal-web/test-results/`


### Known Issues

* Script does not work on Windows because of limitations in GitBash with mounting folders
* Script uses expression to get your machine's IP. The expression might need to be tweaked to work on your network configuration
* build-text.xml does a full modules directory search for poshi toggles. This can have a significant impact on performance when starting up poshi-runner.
* Tests that need to download and then upload a file will not work
