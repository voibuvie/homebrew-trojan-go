class TrojanGo < Formula
  desc "A Trojan proxy written in golang."
  homepage "https://github.com/p4gefau1t/trojan-go"
  url "https://github.com/p4gefau1t/trojan-go/archive/v0.4.7.tar.gz"
  sha256 "594f2ba63e47bf4b3ebd4f76d82c6a0c38c4a02d284c60f7aafb38b356537925"
  head "https://github.com/p4gefau1t/trojan-go.git"

  depends_on "go" => :build

  def install
    system "wget" "https://github.com/v2ray/domain-list-community/raw/release/dlc.dat" "-O" "geosite.dat"
    system "wget" "https://raw.githubusercontent.com/v2ray/geoip/release/geoip.dat" "-O" "geoip.dat"
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-tags", "full"
    (etc/"trojan-go").mkpath
    cp("example/client.json", "example/config.json")
    chmod 0644, "example/client.json"
    chmod 0644, "example/config.json"
    chmod 0644, "example/server.json"
    bin.install "trojan-go"
    etc.install "example/client.json" => "trojan-go/client.json"
    etc.install "example/config.json" => "trojan-go/config.json"
    etc.install "example/server.json" => "trojan-go/server.json"
    etc.install "geosite.dat" => "trojan-go/geosite.dat"
    etc.install "geoip.dat" => "trojan-go/geoip.dat"
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
