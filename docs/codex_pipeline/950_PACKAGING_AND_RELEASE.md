# 950_PACKAGING_AND_RELEASE.md

## Goal

Package the MOD according to official requirements.

## Required Files

A valid distribution contains:

```text
jshyl_mod
jshyl_maps
jshyl.xml
```

All three must be distributed together.

## Platform Specificity

MOD packages are platform-specific.

A PC MOD build is not automatically valid for Android/iOS/OSX.

## Packaging Checklist

```text
[ ] All scenes labeled jshyl_maps
[ ] All non-scene assets labeled jshyl_mod
[ ] No cross-MOD dependencies
[ ] No missing BuildSource files
[ ] ModSetting metadata correct
[ ] jshyl.xml generated
[ ] package tested by selecting MOD in platform UI
```

## Native MOD Option

If shipping bundled with the base app, ModSetting may support native MOD mode.

Only use this deliberately.
