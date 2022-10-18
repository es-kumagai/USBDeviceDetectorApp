//
//  ViewController.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import Cocoa
import Ocean

class ViewController: NSViewController, NotificationObservable {
    
    @IBOutlet private(set) var activityLogView: ActivityLogView!
    
    var notificationCenter = NSWorkspace.shared.notificationCenter
    var notificationHandlers = Notification.Handlers()

    deinit {
    
        notificationHandlers.releaseAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observe(ActivityLogNotification.self) { [unowned self] notification in
            
            activityLogView.appendLog(notification.log)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

