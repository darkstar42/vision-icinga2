# vision_skeleton

[![Build Status](https://travis-ci.org/vision-it/vision_skeleton.svg?branch=production)](https://travis-ci.org/vision-it/vision_skeleton)


## Usage

Include in the *Puppetfile*:

```
mod vision_skeleton:
    :git => 'https://github.com/vision-it/vision_skeleton.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
    contain ::vision_skeleton
```

