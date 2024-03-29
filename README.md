# github.com/tiredofit/parsedmarc

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/parsedmarc?style=flat-square)](https://github.com/tiredofit/parsedmarc/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/parsedmarc/build?style=flat-square)](https://github.com/tiredofit/parsedmarc/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/parsedmarc.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/parsedmarc/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/parsedmarc.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/parsedmarc/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [ParseDMARC](https://domainaware.github.io/parsedmarc/), A tool for parsing aggregate and forensic DMARC reports

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [ParseDMARC Options](#parsedmarc-options)
    - [Mailbox Options](#mailbox-options)
    - [IMAP Options](#imap-options)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/parsedmarc)

```bash
docker pull docker.io/tiredofit/parsedmarc:(imagetag)
```
Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-parsedmarc/pkgs/container/docker-parsedmarc) 
 
```
docker pull ghcr.io/tiredofit/docker-parsedmarc:(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory      | Description         |
| -------------- | ------------------- |
| `/config/`     | Configuration Files |
| `/data/`       | Data Files          |
| `/data/input`  | Input Files         |
| `/data/output` | Output Files        |
| `/logs/`       | Log Files           |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Container Options

| Variable      | Description         | Default                |
| ------------- | ------------------- | ---------------------- |
| `CONFIG_FILE` | Configuration File  | `parsedmarc.conf`      |
| `CONFIG_PATH` | Configuration Path  | `/config/`             |
| `DATA_PATH`   | Data Path           | `/data/`               |
| `LOG_PATH`    | Log Path            | `/logs/`               |
| `LOG_FILE`    | Log File            | `parsedmarc.log`       |
| `INPUT_PATH`  | Input File Path     | `${INPUT_PATH}/input/` |
| `OUTPUT_PATH` | Output Reports Path | `${DATA_PATH}/output/` |
| `SETUP_MODE`  | `AUTO` or `MANUAL`  | `AUTO`                 |

#### ParseDMARC Options
| Variable                 | Description                                       | Default           |
| ------------------------ | ------------------------------------------------- | ----------------- |
| `AGGREGATE_CSV_FILE`     |                                                   | `aggregate.csv`   |
| `AGGREGATE_JSON_FILE`    |                                                   | `aggregate.json`  |
| `NAMESERVERS`            | Nameservers to utilize seperated by commas        | `1.1.1.1,1.0.0.1` |
| `TIMEOUT_DNS`            | Timeout for DNS queries in seconds (franctional)  | `2.0`             |
| `FORENSIC_CSV_FILE`      |                                                   | `forensic.csv`    |
| `FORENSIC_JSON_FILE`     |                                                   | `forensic.json`   |
| `NAMESERVERS`            |                                                   | `1.1.1.1 1.0.0.1` |
| `REPORTS_SAVE_AGGREGATE` |                                                   | `FALSE`           |
| `REPORTS_SAVE_FORENSIC`  |                                                   | `FALSE`           |
| `PARSEDMARC_ARGS`        | Extra arguments to pass when launching ParseDMARC | ``                |
| `TIMEOUT_DNS`            |                                                   | `2.0`             |

#### Mailbox Options

| Variable                 | Description | Default   |
| ------------------------ | ----------- | --------- |
| `MAILBOX_ARCHIVE_FOLDER` |             | `Archive` |
| `MAILBOX_REPORTS_FOLDER` |             | `INBOX`   |
| `MAILBOX_CHECK_INTERVAL` |             | `30`      |
| `MAILBOX_TEST_MODE`      |             | `FALSE`   |
| `MAILBOX_WATCH`          |             | `TRUE`    |


#### IMAP Options
| Variable      | Description                       | Default |
| ------------- | --------------------------------- | ------- |
| `ENABLE_IMAP` | Enable IMAP Mailbox Functionality | `TRUE`  |
| `IMAP_HOST`   |                                   | ``      |
| `IMAP_USER`   |                                   | ``      |
| `IMAP_PASS`   |                                   | ``      |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- [Sponsor me](https://tiredofit.ca/sponsor) for personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- [Sponsor me](https://tiredofit.ca/sponsor) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- [Sponsor me](https://tiredofit.ca/sponsor) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

