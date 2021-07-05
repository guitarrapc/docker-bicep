## docker-bicep

docker image for [bicep](https://github.com/Azure/bicep)

```shell
docker run --rm guitarrapc/docker-bicep:latest --help
```

## Sample

Working dir is `/bicep`, you can mount your files to and run command.
Here's sample to build your bicep to ARM template json.

```shell
docker run --rm -v "PATH_TO_BICEP:/bicep" guitarrapc/docker-bicep:latest build ./main.bicep
```

## Build Image (local)

```shell
docker build -t bicep -f Dockerfile .
docker run -it --rm bicep:latest --help
```
