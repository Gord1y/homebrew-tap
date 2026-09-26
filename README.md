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

This installs the `countersign` CLI at `$(brew --prefix)/bin/countersign` and the menu-bar
companion at `$(brew --prefix)/opt/countersign/Countersign.app`. Run `countersign setup`
afterwards to wire Claude Code and Codex to the approval panel; it can also link the app into
`~/Applications` for you.

### Notes

- **Xcode is a build dependency, not the Command Line Tools.** The Command Line Tools with the
  macOS 27 SDK fail: `external macro implementation type 'SwiftUIMacros.StateMacro' could not be
  found for macro 'State()'; plugin for module 'SwiftUIMacros' not found`, because that SDK's
  SwiftUI expands `@State` through a compiler plugin that ships only with Xcode. The same Command
  Line Tools with the macOS 26.5 SDK build it, but Homebrew cannot know which SDK a user's Command
  Line Tools default to, so the formula depends on `xcode: ["26.0", :build]` rather than
  `uses_from_macos "swift"`.
- **`--disable-sandbox`.** Homebrew already builds formulae inside its own sandbox, and SwiftPM's
  own `sandbox-exec` cannot nest inside it, so `swift build` is invoked with `--disable-sandbox`.
- **The app bundle carries a copy of the binary, not a symlink.** `codesign` rejects a symlinked
  main executable, so the built binary is copied into `Countersign.app/Contents/MacOS/countersign`
  before `bin.install` moves the original into `bin/`.
- **`skip_clean "Countersign.app"`.** Homebrew's keg cleaner removes empty directories after
  install, which would strip the bundle's empty `Contents/Resources/`. `skip_clean` keeps the
  signed bundle exactly as it was signed.
- **The app's version comes from the binary, not a hardcoded string.** `Info.plist` ships with a
  placeholder `0.0.0`; install asks the freshly built binary for `--version` and writes that into
  `CFBundleShortVersionString` and `CFBundleVersion`, so a HEAD build's bundle version and its
  `countersign --version` output can never drift apart.

### Releasing a new version

1. Bump `url` in `Formula/countersign.rb` to the new tag.
2. Compute the new `sha256`: `curl -fsSL <url> | shasum -a 256`.
3. Open a pull request so `brew test-bot` builds bottles for it.
4. Once the pull request is green, run the `brew pr-pull` workflow (`publish.yml`) with the pull
   request number to publish the bottles.

The `sha256` shipped for `v0.1.0` is 64 zeros, a placeholder for a tag that does not exist yet. It
can only ever fail loudly, as a checksum mismatch, and must be replaced with the real value before
this tap is ever pushed.
