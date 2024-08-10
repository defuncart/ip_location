import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var statusBarController: StatusBarController?
  var popover: NSPopover!

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // keep running even when window is closed
    return false
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    let flutterViewController: FlutterViewController =
      mainFlutterWindow?.contentViewController as! FlutterViewController
      
    let popover = NSPopover()
    popover.contentSize = NSSize(width: 160, height: 160)
    popover.behavior = .transient
    popover.contentViewController = flutterViewController
    statusBarController = StatusBarController.init(popover)
    
    // close main
    mainFlutterWindow?.close()

//    super.applicationDidFinishLaunching(aNotification)
  }
}
