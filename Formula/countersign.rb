class Countersign < Formula
  desc "Native approval panel for Claude Code, Codex, Cursor and Antigravity"
  homepage "https://github.com/Gord1y/countersign"
  url "https://github.com/Gord1y/countersign/releases/download/v0.3.0/countersign-0.3.0-macos.tar.gz"
  sha256 "7b5009cbe94ae34ae720a7ba5759973da4f5d5b3377fa7f40097b219ffe29835"
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
      To find it in Spotlight, run `countersign settings` and copy it into ~/Applications from App.
      That copy updates itself after `brew upgrade`.
    EOS
  end

  test do
    assert_equal "", pipe_output("#{bin}/countersign hook --host claude", "not json", 0)
    assert_match(/^countersign \d+\.\d+\.\d+$/, shell_output("#{bin}/countersign --version"))
    system "codesign", "--verify", "--strict", prefix/"Countersign.app"
  end
end
