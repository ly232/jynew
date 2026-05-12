# 950_PACKAGING_AND_RELEASE.md

## Goal

Package the MOD according to official requirements.

## Required Files

A valid distribution contains:

```text
qingqingzijin_mod
qingqingzijin_maps
qingqingzijin.xml
```

All three must be distributed together.

## Platform Specificity

MOD packages are platform-specific.

A PC MOD build is not automatically valid for Android/iOS/OSX.

## Packaging Checklist

```text
[ ] All scenes labeled qingqingzijin_maps
[ ] All non-scene assets labeled qingqingzijin_mod
[ ] No cross-MOD dependencies
[ ] No missing BuildSource files
[ ] ModSettings metadata correct
[ ] qingqingzijin.xml generated
[ ] package tested by selecting MOD in platform UI
```

## Native MOD Option

If shipping bundled with the base app, ModSettings may support native MOD mode.

Only use this deliberately.
