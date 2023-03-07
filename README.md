
# Reproduce existing issue

Checkout the appropriate branch (all branches are cases except `main`)

Build and run the image:
```
docker build -t reprox . && docker run --rm -it reprox
```
It depends on the case itself what will happen.

Preferably the docker build process will halt with an error
By altering the `Dockerfile`, you could remove the problematic step and get a running environment in which the issue could be reproduced / trialed / etc.

# Create new reproduction case

```
# create a new branch from main
git checkout -b case_name main
# pick a sample Dockerfile from samples
cp samples/Dockerfile.simple Dockerfile
# edit the Dockerfile as needed
```

## usage during repro creation

If the image build is successfull; the resulting image can be launched and used (postgres will be launched during launch of the container):
```
docker build -t reprox . && docker run --rm -it reprox
```

## connecting to PG from the host

You may also connect to the PG running inside the container
* `postgres` password is `test` right now
* if you want to be able to connect to the container by its name you might want to use something like: https://github.com/dvddarias/docker-hoster


## Notes
* Create sql files and add more heavyweight ones as separate steps in the Dockerfile to save time.
* use `git worktree` if you have to work with multiple repros
