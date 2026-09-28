class Countersign < Formula
  desc "Native approval panel for Claude Code, Codex, Cursor and Antigravity"
  homepage "https://github.com/Gord1y/countersign"
  url "https://github.com/Gord1y/countersign/releases/download/v0.1.0/countersign-0.1.0-macos.tar.gz"
  sha256 "c12bf3a3a21d5a6ff8f5af80b46825e452c1887bac8595cc3490d8231b75b81e"
  license "GPL-3.0-only"

  depends_on macos: :sonoma

  skip_clean "Countersign.app"

  def install
    bin.install "countersign"
    prefix.install "Countersign.app"
  end

  def caveats
    <<~EOS
      Run `countersign setup` to wire Claude Code, Codex, Cursor and Antigravity to the approval panel.

      The menu-bar app is optional: the command-line tool works without it. It is at:
        #{opt_prefix}/Countersign.app
      The Settings window `countersign setup` opens can link it into ~/Applications.
    EOS
  end

  test do
    assert_equal "", pipe_output("#{bin}/countersign hook --host claude", "not json", 0)
    assert_match(/^countersign \d+\.\d+\.\d+$/, shell_output("#{bin}/countersign --version"))
    system "codesign", "--verify", "--strict", prefix/"Countersign.app"
  end
end
