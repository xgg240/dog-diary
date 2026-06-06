import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    // 默认窗口大小 1280x900, 居中
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900)
    let winW: CGFloat = 1280
    let winH: CGFloat = 900
    let x = (screenSize.width - winW) / 2
    let y = (screenSize.height - winH) / 2
    self.setFrame(NSRect(x: x, y: y, width: winW, height: winH), display: true)
    // 允许任意缩小 (iPhone 级别) - 之前 900x600 是元凶
    self.minSize = NSSize(width: 320, height: 480)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
