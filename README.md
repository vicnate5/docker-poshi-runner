# docker-poshi-runner
Run poshi tests headlessly using docker.

## Setup
1. Install Docker [Windows](https://docs.docker.com/windows)/[Mac](https://docs.docker.com/mac)/[Linux](https://docs.docker.com/linux)
2. Set docker virtual machine memory to at least 2gb (4gb recommended)
3. Clone this repo (or just download the **run_test.sh** script file)

A built image is hosted at https://hub.docker.com/r/vicnate5/functional-test-runner/ so you do not need to build the Dockerfile unless you want to make changes to it.

## Running a test with the script (Mac/Linux only)

1. Start a local Portal server
2. From the root directory of your Portal source code, copy over and run the script:
```
./run_test.sh {testname}
```
e.g.
```
./run_test.sh PortalSmoke#Smoke
```

## Runing a test manually
1. Start a local Portal server
4. From the root directory of your Portal source code, run the following command:

#### Windows (use windows command line, will not work in gitbash)<br />
(Replace TESTNAME)
```
docker run -t --rm -v %cd%:/source vicnate5/functional-test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.url=http://docker.for.win.localhost:8080 -Dtest.skip.tear.down=true -Dtest.assert.console.errors=false -Dtest.class=TESTNAME"
```

#### Mac
(Replace TESTNAME)
```
docker run -t --rm -v $(pwd):/source:cached vicnate5/functional-test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test -Dtest.url=http://docker.for.mac.localhost:8080 -Dtest.skip.tear.down=true -Dtest.assert.console.errors=false -Dtest.class=TESTNAME"
```

#### Linux
(Replace TESTNAME and PORTALURL)
```
docker run -t --rm -v $(pwd):/source:cached vicnate5/functional-test-runner /bin/bash -c "/run.sh; cd /source; ant -f build-test.xml run-selenium-test  -Dtest.skip.tear.down=true -Dtest.assert.console.errors=false -Dtest.class=TESTNAME -Dtest.url=PORTALURL"
```


Note: Results will be stored in the normal location as the docker container simply mounts your source folder
* `{source_dir_path}/portal-web/test-results/`


### Known Issues

* Script does not work on Windows because of limitations in GitBash with mounting folders
* Script uses expression to get your machine's IP. The expression might need to be tweaked to work on your network configuration
* build-text.xml does a full modules directory search for poshi toggles. This can have a significant impact on performance when starting up poshi-runner.

#### Mounting your bundle directory
If you are using the default manual steps, your bundle will not be mounted to the image. This means that:
* Console errors will not be caught by the test
* `-Dtest.assert.console.errors=false` is set to prevent errors being thrown for the missing logs
* Tests that need to download and then upload a file will not work

You can add a mount of the bundle directory by using another `-v` flag to the docker run expression. If you bundle is not in the default location (../bundles), you also need to set `app.server.parent.dir` in `app.server.root.properties`.

If you are using the script, it will take care of all of this configuration and mount the bundle for you.
