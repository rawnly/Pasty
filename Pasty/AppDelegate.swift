//
//  AppDelegate.swift
//  Pasty
//
//  Created by Federico Vitale on 22/05/2019.
//  Copyright © 2019 Federico Vitale. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var timer: Timer!
    let pasteboard: NSPasteboard = .general
    let windowController = NSWindowController(window: nil)
    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var lastChangeCount: Int = 0 {
        didSet {
            statusItem.button?.title = "\(self.lastChangeCount)"
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
            if self.lastChangeCount != self.pasteboard.changeCount {
                self.lastChangeCount = self.pasteboard.changeCount
                NotificationCenter.default.post(name: .NSPasteboardDidChange, object: self.pasteboard)
            }
        }
        
        if let button = statusItem.button {
            button.title = "\(self.lastChangeCount)"
            button.target = self
            button.sendAction(on: [.rightMouseUp, .leftMouseUp])
            button.action = #selector(openWindow)
        }
        
        
        self.openWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        timer.invalidate()
    }
    
    @objc
    func openWindow() {
        if windowController.window == nil {
            guard let vc = getVC(withIdentifier: "ViewController", ofType: ViewController.self) else { return }
            let window = NSWindow(contentViewController: vc)
            window.styleMask.removeMultiple(.fullScreen, .miniaturizable, .resizable)
            windowController.window = window
        }
        
        windowController.showWindow(self)
    }
}



