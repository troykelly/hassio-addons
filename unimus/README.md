
# Community Hass.io Add-ons: Unimus

[![Release][release-shield]][release] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]
![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

[![Discord][discord-shield]][discord] [![Community Forum][forum-shield]][forum]

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[Unimus][unimus-home] is a networking equipment configuration management solution.

## About

**IMPORTANT**: _Unimus is a paid service for more than 5 devices_

The Hass.io Unimus add-on allows you to run a local Unimus server.

## Installation

The installation of this add-on is straightforward and easy to do.

1. Navigate in your Home Assistant frontend to **Hass.io** -> **Add-on Store**.
2. Add a new repository by URL `https://github.com/troykelly/hassio-addons`
3. Find the "unimus" add-on and click it.
4. Click on the "INSTALL" button.

## How to use

To use this add-on, you need to supply the config for Unimus to connect to your database.

- Requires you have a mariadb server available (can I suggest another addon)
- You will need your licence key from the [Unimus Portal][unimus-portal]

You always need to provide the following entries within the configuration:

**Really Important**
The first time you launch Unimus - you will be taken to the wizard. If you make changes to the settings in the wizard, they will work until your addon restarts and the configuration file is overwritten.

```json
{
  "license": {
    "key": "L-d348ee9a-3525-417b-923d-54cd0008d12b"
  },
  "encryption": {
    "key": "reallyCoMPlex-Key-HERE"
  },
  "database": {
    "host": "core-mariadb",
    "port": "3306",
    "name": "unimus",
    "user": "unimus",
    "password": "supersecret"
  },
  "ssl": false,
  "certfile": "fullchain.pem",
  "keyfile": "privkey.pem"
}
```

[Click here for the full documentation][docs]

![Unimus Screenshot][screenshot]

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/UzEsqIw
[discord-shield]: https://img.shields.io/discord/478094546522079232.svg
[discord]: https://discord.me/hassioaddons
[docs]: https://github.com/troykelly/hassio-addon-unimus/blob/master/README.md
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io/c/hass-io
[maintenance-shield]: https://img.shields.io/maintenance/yes/2019.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
[release-shield]: https://img.shields.io/badge/version-v2.0.10-blue.svg
[release]: https://github.com/troykelly/hassio-addon-unimus/tree/v2.0.10
[screenshot]: https://unimus.net/images/screenshots/3.png
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[unimus-home]: https://unimus.net/
[unimus-portal]: https://portal.unimus.net/
