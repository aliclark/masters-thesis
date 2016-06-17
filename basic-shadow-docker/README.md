
Goals
-----

 * Run a basic Shadow simulation of C programs sending data using QUIC

Current status
--------------

 * Runnable Dockerfile to setup Shadow

 * Can run the hello-world Shadow plugin

TODO
----

 * Run the QUIC code in its own Shadow plugin

Lessons learned
---------------

 * Building or compiling Shadow v1.10.x and v.11.x tends to have difficulties
   on fedora-23 and debian-8

 * Shadow's dependency version requirements are fulfilled by the fedora-22
   packages, so building off the fedora:22 Docker image seems reasonable

 * Qubes starts with a 10G root.img which might not be large enough for the
   final Docker image. These instructions can be followed to increase the
   root.img size: https://www.qubes-os.org/doc/resize-root-disk-image/

Build and Run
-------------

Feel free to submit an issue on this project if anything here doesn't work

```sh
# fedora:
sudo dnf     install git docker
# debian:
sudo apt-get install git docker-engine

git clone https://github.com/aliclark/masters-thesis

cd masters-thesis/basic-shadow-docker/
docker build -t shadow .
docker run shadow
```
