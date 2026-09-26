class Countersign < Formula
  desc "Native approval panel for Claude Code and Codex permission requests"
  homepage "https://github.com/Gord1y/countersign"
  url "https://github.com/Gord1y/countersign/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "GPL-3.0-only"
  head "https://github.com/Gord1y/countersign.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sonoma

  skip_clean "Countersign.app"

  def install
    system "swift", "build", "--disable-sandbox", *std_swift_args, "--product", "countersign"
    built_binary = ".build/release/countersign"

    app = buildpath/"Countersign.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp built_binary, app/"Contents/MacOS/countersign"
    cp "scripts/app/Info.plist", app/"Contents/Info.plist"

    version_string = Utils.safe_popen_read(built_binary, "--version").chomp.delete_prefix("countersign ")
    system "plutil", "-replace", "CFBundleShortVersionString", "-string", version_string, app/"Contents/Info.plist"
    system "plutil", "-replace", "CFBundleVersion", "-string", version_string, app/"Contents/Info.plist"
    (app/"Contents/PkgInfo").write "APPL????"

    system "codesign", "--force", "--sign", "-", app

    bin.install built_binary
    prefix.install app
  end

  def caveats
    <<~EOS
      Run `countersign setup` to wire Claude Code and Codex to the approval panel.

      The menu-bar app is installed at:
        #{opt_prefix}/Countersign.app
      `countersign setup` can link it into ~/Applications for you.
    EOS
  end

  test do
    assert_equal "", pipe_output("#{bin}/countersign hook --host claude", "not json", 0)
    assert_match(/^countersign \d+\.\d+\.\d+$/, shell_output("#{bin}/countersign --version"))
    system "codesign", "--verify", "--strict", prefix/"Countersign.app"
  end
end
