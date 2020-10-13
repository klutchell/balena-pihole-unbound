# balena-pihole-unbound

If you're looking for a way to quickly and easily get up and running with a Pi-hole device for your home network, this is the project for you.

This project is a [balenaCloud](https://www.balena.io/cloud) stack with the following services:

- [Pi-hole](https://hub.docker.com/r/pihole/pihole/) (including [PADD](https://github.com/jpmck/PADD))
- [unbound](https://unbound.net/)
- [duplicati](https://www.duplicati.com/)
- [wireguard](https://www.wireguard.com/)

balenaCloud is a free service to remotely manage and update your Raspberry Pi through an online dashboard interface, as well as providing remote access to the Pi-hole web interface without any additional configuation.

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![](https://balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-pihole-unbound&defaultDeviceType=raspberry-pi)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application, flashing a device, downloading the project and pushing it via either Git or the [balena CLI](https://github.com/balena-io/balena-cli).

### Application Environment Variables

Application envionment variables apply to all services within the application, and can be applied fleet-wide to apply to multiple devices.

| Name | Example           | Purpose                                                                                                                                                                                                                          |
| ---- | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TZ` | `America/Toronto` | To inform services of the timezone in your location, in order to set times and dates within the applications correctly. Find a [list of all timezone values here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones). |

## Usage

### pi-hole

<https://www.balena.io/blog/deploy-network-wide-ad-blocking-with-pi-hole-and-a-raspberry-pi/>

Connect to `http://<device-ip>:80/admin` and log in to the dashboard with your provided root password.

Device service variables are available to the code running on the specified service on this particular device. If both the application and the device have a service variable of the same name and service, the code on this device will see the value of the device service variables. In other words, device service variables redefine (or override) application-wide service variables of the same name and service.

| Name                | Example            | Purpose                                                                                                                                                                             |
| ------------------- | ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DNSMASQ_LISTENING` | `eth0`             | We set this to `eth0` to indicate we want DNSMASQ to listen on the ethernet interface of the Raspberry Pi. If you're connecting to your network with WiFi replace this with `wlan0` |
| `INTERFACE`         | `eth0`             | As above.                                                                                                                                                                           |
| `WEBPASSWORD`       | `mysecretpassword` | _(optional)_ password for accessing the web-based interface of Pi-hole - you won’t be able to access the admin panel without defining a password here.                              |
| `DNS1`              | `127.0.0.1#5053`   | _(optional)_ Tell Pi-hole where to forward DNS requests that aren’t blocked. We’re using the [unbound](https://unbound.net/) project here but you can specify your own.             |
| `DNS2`              | `127.0.0.1#5053`   | _(optional)_ Secondary DNS server - see above.                                                                                                                                      |
| `ServerIP`          | `x.x.x.x`          | _(recommended)_ Set to your server's LAN IP, used by web block modes and lighttpd bind address.                                                                                     |

## PADD

Here's a guide to add a display to your Pi-hole for monitoring and stats:

<https://www.balena.io/blog/add-a-display-to-your-pi-hole-for-monitoring-and-stats/>

### wireguard

<https://docs.linuxserver.io/images/docker-wireguard>

Device service variables are available to the code running on the specified service on this particular device. If both the application and the device have a service variable of the same name and service, the code on this device will see the value of the device service variables. In other words, device service variables redefine (or override) application-wide service variables of the same name and service.

| Name        | Example                | Purpose                                                                                                                                                                  |
| ----------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SERVERURL` | `wireguard.domain.com` | _(optional)_ External IP or domain name for docker host. Used in server mode. If set to auto, the container will try to determine and set the external IP automatically. |
| `PEERS`     | `4`                    | _(required)_ Number of peers to create confs for. Required for server mode.                                                                                              |
| `PEERDNS`   | `x.x.x.x`              | _(recommended)_ Set to your server's LAN IP, used to assign Pi-hole as the DNS server for wireguard clients.                                                             |

### duplicati

<https://docs.linuxserver.io/images/docker-duplicati>

Connect to `http://<device-ip>:8200` and configure a new backup using any online service you prefer as the Destination and `/source` as Source Data.

## Help

If you're having trouble getting the project running, submit an issue or post on the forums at <https://forums.balena.io>.

## References

- <https://hub.docker.com/r/pihole/pihole/>
- <https://hub.docker.com/r/klutchell/unbound/>
- <https://docs.linuxserver.io/images/docker-duplicati>
- <https://docs.linuxserver.io/images/docker-wireguard>
- <https://github.com/balena-os/kernel-module-build>
- <https://github.com/jaredallard-home/wireguard-balena-rpi>
- <https://www.balena.io/blog/deploy-network-wide-ad-blocking-with-pi-hole-and-a-raspberry-pi/>
- <https://www.balena.io/blog/how-to-run-wireguard-vpn-in-balenaos/>
- <https://www.balena.io/blog/add-a-display-to-your-pi-hole-for-monitoring-and-stats/>
- <https://www.raspberrypi.org/forums/viewtopic.php?p=1137258>

## License

[MIT License](./LICENSE)
