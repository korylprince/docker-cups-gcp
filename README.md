# About

This repo contains Dockerfiles and a Docker Compose file for running a CUPS server and Google Cloud Print Connector in Docker.

There's a cups-canon container that includes a CUPS server with the Canon UFR II driver installed. This is separate because the driver conflicts with the connector process for some reason.

There's also a "resumer" container that just tries to resume the specified printers every minute. We needed this for some older printers that tend to pause when they run out of toner or paper.
