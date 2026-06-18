# Ganglia Docker Container for Rocky Linux 9.6

## Overview

This repository provides a containerized deployment of Ganglia Monitoring System for High Performance Computing (HPC) clusters using Rocky Linux 9.6.

The container includes:

* Ganglia Monitoring Daemon (gmond)
* Ganglia Meta Daemon (gmetad)
* Ganglia Web Interface
* Apache HTTP Server
* PHP
* Supervisor Process Manager

The image is designed for monitoring large-scale HPC clusters and can be integrated with compute nodes, GPU nodes, login nodes, storage servers, and management nodes.

---

## Features

* Rocky Linux 9.6 based container
* Ganglia Web Dashboard
* Cluster-wide monitoring support
* Support for CPU, Memory, Network, and Disk metrics
* Supervisor-managed services
* Docker deployment
* Easy integration with HPC environments
* Suitable for xCAT and Slurm-managed clusters

---

## Repository Structure

```text
.
├── Dockerfile
├── supervisord.conf
├── entrypoint.sh
├── httpd_initscripts/
├── etc_ganglia/
│   ├── gmond.conf
│   ├── gmetad.conf
│   └── conf.php
├── images/
└── README.md
```

---

## Building the Docker Image

Clone the repository:

```bash
git clone <repository_url>
cd ganglia-docker
```

Build the image:

```bash
docker build --network host -t cdac_ganglia:rocky9.6 .
```

Verify image creation:

```bash
docker images | grep cdac_ganglia
```

---

## Running the Container

### Basic Deployment

```bash
docker run -d \
  --name ganglia \
  --hostname ganglia \
  -p 8080:80 \
  -p 8649:8649/udp \
  -p 8651:8651 \
  -p 8652:8652 \
  cdac_ganglia:rocky9.6
```

---

### Persistent RRD Storage

To preserve historical monitoring data:

```bash
mkdir -p /opt/ganglia/rrds
```

```bash
docker run -d \
  --name ganglia \
  --hostname ganglia \
  -v /opt/ganglia/rrds:/var/lib/ganglia/rrds \
  -p 8080:80 \
  -p 8649:8649/udp \
  -p 8651:8651 \
  -p 8652:8652 \
  cdac_ganglia:rocky9.6
```

---

## Accessing Ganglia Web UI

Open the following URL in your browser:

```text
http://<server-ip>:8080/ganglia
```

Example:

```text
http://192.168.1.100:8080/ganglia
```

---

## Service Verification

Enter the container:

```bash
docker exec -it ganglia bash
```

Verify services:

```bash
supervisorctl status
```

Expected output:

```text
gmond      RUNNING
gmetad     RUNNING
httpd      RUNNING
```

---

## Verify Listening Ports

```bash
ss -lntup
```

Expected ports:

| Service     | Port |
| ----------- | ---- |
| gmond       | 8649 |
| gmetad XML  | 8652 |
| Web UI      | 80   |
| gmetad data | 8651 |

---

## Common Troubleshooting

### gmetad Fails to Start

Check configuration:

```bash
cat /etc/ganglia/gmetad.conf
```

Run manually:

```bash
gmetad -f
```

---

### Web UI Shows

```text
There was an error collecting ganglia data (127.0.0.1:8652)
```

Verify:

```bash
ss -lntp | grep 8652
```

If nothing is listening:

```bash
supervisorctl restart gmetad
```

Check logs:

```bash
tail -f /var/log/ganglia/gmetad.log
```

---

### gmond Not Reporting Metrics

Verify:

```bash
gmond -t
```

Check port:

```bash
ss -lunp | grep 8649
```

---

## Docker Logs

View container logs:

```bash
docker logs -f ganglia
```

---

## Stop Container

```bash
docker stop ganglia
```

---

## Remove Container

```bash
docker rm -f ganglia
```

---

## HPC Cluster Integration

The container can be integrated with:

* xCAT
* Slurm
* PBS/Torque
* OpenHPC
* LDAP
* Lustre File System
* NFS Storage
* InfiniBand Networks
* NVIDIA GPU Clusters

---

## Recommended Enhancements for Large HPC Clusters (10–20 PFLOPS)

### GPU Monitoring

Collect:

* GPU Utilization
* GPU Memory Usage
* GPU Temperature
* Power Consumption
* ECC Errors

using:

```bash
nvidia-smi
```

---

### Slurm Monitoring

Export:

* Running Jobs
* Pending Jobs
* GPU Allocations
* Queue Wait Times

using:

```bash
squeue
sinfo
sacct
```

---

### InfiniBand Monitoring

Monitor:

* Port Errors
* Link Down Events
* Bandwidth Usage
* Symbol Errors

using:

```bash
perfquery
ibqueryerrors
```

---

### Lustre Monitoring

Collect:

* MDT Usage
* OST Usage
* Read Throughput
* Write Throughput

using:

```bash
lctl
```

---

## Maintainer

CDAC HPC Team

Project: OpenCHAI HPC Suite

Platform: Rocky Linux 9.6

Container Runtime: Docker
