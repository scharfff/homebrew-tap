# homebrew-tap

[![Tap](https://github.com/scharfff/homebrew-tap/actions/workflows/tap.yml/badge.svg)](https://github.com/scharfff/homebrew-tap/actions/workflows/tap.yml)

Homebrew tap for apps by [scharfff](https://github.com/scharfff).

| Cask | What |
|---|---|
| `tapkeys` | [TapKeys](https://github.com/scharfff/tapkeys): free trackpad gestures for macOS, in the menu bar |

## Install

```bash
brew install --cask scharfff/tap/tapkeys
```

The fully qualified name installs the cask and trusts only it (Homebrew asks for explicit trust of third-party taps since 6.0.0). You do not need to run `brew tap` first.

## First launch

TapKeys is open source, signed ad hoc and not notarized (no Apple Developer ID). Homebrew keeps the quarantine flag on casks, so macOS blocks the first launch:

1. Open TapKeys, close the warning.
2. System Settings, Privacy & Security, scroll down, click **Open Anyway**.
   (On macOS 15 and newer, right-click and Open no longer bypasses the check.)
3. Grant **Accessibility** access when macOS asks.

Instead of step 2 you can remove the quarantine flag by hand, which is your own decision about this app:

```bash
xattr -dr com.apple.quarantine /Applications/TapKeys.app
```

The ad hoc signature changes with every release. After `brew upgrade` macOS may ask for Accessibility access again: remove the old TapKeys entry from the list and add it back.

## Update and remove

```bash
brew upgrade --cask tapkeys
brew uninstall --cask tapkeys
brew uninstall --cask --zap tapkeys   # also removes preferences
```

`--zap` deletes the preferences file (`~/Library/Preferences/io.github.scharfff.tapkeys.plist`). Homebrew cannot touch the Accessibility list: remove the TapKeys entry in System Settings, or run `tccutil reset Accessibility io.github.scharfff.tapkeys`.

## How the cask is updated

The release workflow in [scharfff/tapkeys](https://github.com/scharfff/tapkeys) publishes the GitHub release first and only then updates `version` and `sha256` in `Casks/tapkeys.rb`, using the secret `HOMEBREW_TAP_TOKEN` (a fine-grained token with Contents read and write on this repository only). After the push it downloads the cask URL and checks that the sha256 matches. Without the secret the release is still published and the workflow prints the two values for a manual edit. Prereleases (tags like `v0.3.0-rc1`) never touch the cask.

## Checks

The workflow `Tap` runs on every push to `main`, every pull request and once a week:

- `brew style` for the whole tap;
- `brew audit --cask --strict` for `tapkeys` (offline checks, always);
- `brew audit --cask --strict --online`, then an install and uninstall of the cask. These need a published release, so they are skipped with a notice while the URL in the cask does not exist yet.

The workflow uses the Homebrew action `setup-homebrew`, which links the checkout into Homebrew as the tap `scharfff/tap` and trusts it. The check to require for the `main` branch is **Style and audit**.

To run the same checks on your Mac (a tap must be installed and trusted first, `brew audit` does not take file paths):

```bash
brew tap scharfff/tap
brew trust scharfff/tap
brew style scharfff/tap
brew audit --cask --strict scharfff/tap/tapkeys
```

Updating the cask by hand: change `version` and `sha256` (the sha256 is the line for `TapKeys-v<version>.zip` in `SHA256SUMS` of the release), then run the checks above.
