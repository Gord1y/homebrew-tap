class Countersign < Formula
  desc "Native approval panel for Claude Code, Codex, Cursor and Antigravity"
  homepage "https://github.com/Gord1y/countersign"
  url "https://github.com/Gord1y/countersign/releases/download/v0.1.0/countersign-0.1.0-macos.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
