# Gord1y Tap

## How do I install these formulae?

`brew install gord1y/tap/<formula>`

Or `brew tap gord1y/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "gord1y/tap"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Countersign

```sh
brew install gord1y/tap/countersign
```

This installs the `countersign` CLI at `$(brew --prefix)/bin/countersign` and the optional
menu-bar companion at `$(brew --prefix)/opt/countersign/Countersign.app`; the CLI works without
it. Run `countersign setup` afterwards to wire Claude Code, Codex, Cursor and Antigravity to the
approval panel; the Settings window it opens can also link the app into `~/Applications`.

### Notes

- **Installs a prebuilt release, not a build.** `url` points at the universal (`arm64` +
  `x86_64`) tarball the main repo's `release.yml` publishes for each tag, so `brew install`
  downloads `countersign` and `Countersign.app` already built and ad-hoc signed. Nothing is
  compiled on the Mac running `brew install`, and no Xcode is required.
- **A formula, not a cask.** Homebrew only quarantines files a cask installs; a formula's
  downloads never get `com.apple.quarantine`, so the ad-hoc signed binary and app run without a
  Gatekeeper prompt. A cask would sit quarantined and blocked until the app is notarized.
- **`skip_clean "Countersign.app"`.** Homebrew's keg cleaner removes empty directories after
  install, which would strip the bundle's empty `Contents/Resources/`. `skip_clean` keeps the
  signed bundle exactly as it was signed.

### Releasing a new version

1. Wait for the main repo's `release.yml` to publish `countersign-<version>-macos.tar.gz` on the
   GitHub release for the tag.
2. Bump `url` in `Formula/countersign.rb` to that release asset.
3. Compute the new `sha256`: `curl -fsSL <url> | shasum -a 256`, and set it in the formula.
4. Commit and push.

No bottles are built or published for this formula: `url` already points at a prebuilt binary, so
there is nothing for `brew test-bot` to bottle and nothing for a `brew pr-pull` workflow to
publish. `publish.yml`, the generated `brew pr-pull` workflow, has been removed. `tests.yml` still
runs `brew test-bot --only-formulae` to install and test the formula, without the bottle-artifact
upload step it no longer needs.
