docker-ns3
==========

1. Build
```
docker build -t ns3 github.com/h3dema/docker-ns3
```
2. Run
```
docker run -it ns3 -p 22
```


# Other option

There is another implementation of a ns-3 container with Ubuntu 22.04 and ns 3.44.

```bash
cd docker-ns3
git checkout ubuntu-22
```