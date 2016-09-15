# vision-icinga2

[![Build Status](https://travis-ci.org/vision-it/vision-icinga2.svg?branch=production)](https://travis-ci.org/vision-it/vision-icinga2)

## Parameters
### Client
##### String `vision_icinga2::parent_zone`
No default. Zonename of the parent, to which the client belongs

### Server


###### String `vision_icinga2::server::client_zone`
Default: `fqdn`.

###### String `vision_icinga2::parent_zone`
No default. Use if the icinga master has another parent.

##### Database
Mysql is installed and configured in this profile.

###### String `vision_icinga2::server::mysql_user`
Default: `icinga2`.

###### String `vision_icinga2::server::mysql_password`
No default.

###### String `vision_icinga2::server::mysql_database`
Default: `icinga2`.

###### String `vision_icinga2::server::mysql_root_password`
No default.

##### Api

###### String `vision_icinga2::server::api_user`
Default: `icinga2`.

###### String `vision_icinga2::server::api_password`
No default.

##### Notifications

###### Hash `vision_icinga2::server::notification_users`
No default.

###### Hash `vision_icinga2::server::notification_groups`
No default.

###### String `vision_icinga2::server::notification_group`
###### String `vision_icinga2::server::notification_email`
###### String `vision_icinga2::server::notification_slack_icinga_host`
Default: fqdn.
###### String `vision_icinga2::server::notification_slack_webhook_url`
###### String `vision_icinga2::server::notification_slack_channel`
Default: `monitoring`.
###### String `vision_icinga2::server::notification_bot_name`
Default: `icinga2`.

## Installation

Include in the *Puppetfile*:

```
mod vision_icinga2:
    :git => 'https://github.com/vision-it/vision-icinga2.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_icinga2::client

contain ::vision_icinga2::server
```

