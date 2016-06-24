# vision-skeleton

[![Build Status](https://travis-ci.org/vision-it/vision-skeleton.svg?branch=production)](https://travis-ci.org/vision-it/vision-skeleton)


## Usage

Include in the *Puppetfile*:

```
mod vision_skeleton:
    :git => 'https://github.com/vision-it/vision-skeleton.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_skeleton
```

