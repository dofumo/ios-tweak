# AzotaPanel (iOS Theos tweak)

A small native floating-button/panel prototype scoped to the official Azota Student iOS bundle ID `azt.azt`.

## What this build does

- Injects a draggable native `Aa` button into the Azota Student app window.
- Tapping it opens a small native panel.
- The panel includes a personal notes text area and a close button.
- It does not hook WebKit, read page/question text, select answers, submit forms, disable screenshots, or alter app security controls.

## Target and compatibility

- Bundle ID filter: `azt.azt`.
- Rootless package, iOS 15+.
- Built for `arm64` app processes.
- Requires a jailbreak/injection environment that supports Theos/Substrate-compatible tweaks.
- This is a UI prototype. It has not been tested on a physical device or with a specific Azota iOS build.

## Build with GitHub Actions

1. Create a repository and upload these files.
2. Open **Actions → Build AzotaPanel tweak → Run workflow** (or push to `main`/`master`).
3. Download artifact `AzotaPanel-rootless`.
4. The artifact contains the `.deb` and `AzotaPanel.dylib` when the build succeeds.

The workflow uses `Randomblock1/theos-action` to prepare Theos and the iOS SDK, then runs `make package`.

## Local build (with Theos installed)

```sh
make clean
make package THEOS_PACKAGE_SCHEME=rootless FINALPACKAGE=1
```

The resulting Debian package is placed under `packages/`.

## Notes

- Do not install a rootless package on a rootful jailbreak or vice versa.
- If the tweak causes instability, disable/remove the tweak from the jailbreak's tweak manager or package manager.
- The native panel is intentionally isolated from Azota's WebView and assessment controls.
