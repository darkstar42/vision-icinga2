# vision-icinga2

[![Build Status](https://travis-ci.org/vision-it/vision-icinga2.svg?branch=production)](https://travis-ci.org/vision-it/vision-icinga2)


## Usage

Include in the *Puppetfile*:

```
mod vision_icinga2:
    :git => 'https://github.com/vision-it/vision-icinga2.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_icinga2
```

