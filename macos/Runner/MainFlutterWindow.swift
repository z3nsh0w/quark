import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
  
    self.styleMask.insert(.fullSizeContentView)
    
    self.backgroundColor = NSColor.clear
    
    self.hasShadow = false

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}