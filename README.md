## docker-bicep

docker image for [bicep](https://github.com/Azure/bicep)

```shell
docker run --rm guitarrapc/docker-bicep:latest --help
```

## local build

```shell
docker build -t bicep -f Dockerfile .
docker run -it --rm bicep:latest --help
```