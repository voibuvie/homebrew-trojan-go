class TrojanGo < Formula
  desc "A Trojan proxy written in golang."
  homepage "https://github.com/p4gefau1t/trojan-go"
  url "https://github.com/p4gefau1t/trojan-go/archive/v0.4.2.tar.gz"
  sha256 "aac90065dd5b7706dc2080e6458dc74ab3885c16474cf0fe40d6ec3b19665ed3"
  head "https://github.com/p4gefau1t/trojan-go.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath"
    (etc/"trojan-go").mkpath
    cp("data/client.json", "data/config.json")
    chmod 0644, "data/client.json"
    chmod 0644, "data/config.json"
    chmod 0644, "data/server.json"
    bin.install "trojan-go"
    etc.install "data/client.json" => "trojan-go/client.json"
    etc.install "data/config.json" => "trojan-go/config.json"
    etc.install "data/server.json" => "trojan-go/server.json"
  end

  plist_options :manual => "trojan-go -config #{HOMEBREW_PREFIX}/etc/trojan-go/config.json"

  def plist; <<~EOS
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>RunAtLoad</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/trojan-go</string>
        <string>-config</string>
        <string>#{etc}/trojan-go/config.json</string>
      </array>
    </dict>
  </plist>
  EOS
  end

  test do
    system bin/"trojan-go", "-version"
  end
end
