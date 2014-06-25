# Run a static website as a tor hidden service.

First we check out the repository with the dockerfiles.

```
git clone https://github.com/dreid/docker-tor-static-files/
cd docker-tor-static-files
```

Then we build the docker image for our static webserver:

`docker build -t tor-static-files .`

Next we create an image and container for holding our static files, you could also
just mount a path on the host filesystem instead:

```
docker build -t www_root site
docker run -d --name www_root www_root
```

Then we need somewhere to persist our hidden service information (this is a directory that contains a hostname and a private key, we want to persist it so that we can restart the static file container without losing the private key:

`docker run -d -v /hidden_service --name hidden_service busybox`

Finally we can start our static file server using `--volumes-from` to
mount the previously mentioned `hidden_service` and `www_root` containers:

`docker run -d --volumes-from hidden_service --volumes-from www_root tor-static-files`

Now all we need is to get the hostname, which we can do by simply running cat
in a container that has mounted our hidden_service container:

`docker run -i -t --volumes-from hidden_service busybox cat /hidden_service/hostname`
