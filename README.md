# Basic commands for the ns3 docker container

- Build

```bash
docker-compose build
```

- Start

```bash
docker-compose up -d
```

- Stop

```bash
docker-compose build
```

# Test the installation

- Access the console

```bash
docker-compose exec ns3 /bin/bash
```
This will give you access to the ns3 container shell.

- Run the examples

```bash
cdns3
cd ns-3-dev
ns3 run examples/routing/simple-global-routing.cc
# `ls ..` to see simple-global-routing*.pcap and simple-global-routing.tr files
ns3 run src/zigbee/examples/zigbee-nwk-routing-grid.cc > ../zigbee-grid.log
ns3 run src/zigbee/examples/zigbee-nwk-routing.cc > ../zigbee-routing.log
# will create a log file with the log of the simulation
ns3 run examples/energy/energy-model-with-harvesting-example.cc
# list the use of energy of devices
```

`cdns3` is an alias that `cd` to the `ns3` directory.

- LTE

```
NS_LOG="LteNetDevice" ns3 run src/lte/examples/lena-uplink-power-control.cc
NS_LOG="LteUePowerControl" ns3 run src/lte/examples/lena-uplink-power-control.cc
```
