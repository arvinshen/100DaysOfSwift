//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Arvin Shen on 1/5/22.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var timeInterval: Double?
    var defaultTimeInterval = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("User Authorization Granted!")
            } else {
                print("User Authorization Denied!")
            }
        }
    }
    
    @objc func scheduleLocal(timeInterval: Double) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger: UNTimeIntervalNotificationTrigger
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        if timeInterval <= defaultTimeInterval {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: defaultTimeInterval, repeats: false)
        } else {
            self.timeInterval = timeInterval
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeInterval!, repeats: true)
        }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later")
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                let ac = UIAlertController(title: "Local Notifications", message: "You swiped right to open app", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
                print("Default identifier")
                
            case "show":
                // the user tapped out "show more info..." button
                let ac = UIAlertController(title: "Local Notifications", message: "You tapped \"Show more info\" to open app", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
                print("Show more information...")
                
            case "remind":
                // the user tapped "remind me later" button
                DispatchQueue.main.async {
                    self.scheduleLocal(timeInterval: 60)
                    print("Reminder in 24hrs")
                }
                
            default:
                break
            }
        }
        
        // must call the completion handler when done
        completionHandler()
    }
}

