//
//  ActionViewController.swift
//  Extension
//
//  Created by Arvin Shen on 1/5/22.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!

    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseScript))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // extensionContext lets us control how it interacts with the parent app.
        // inputItems will be an array of data the parent app is sending to our extension to use.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                // loadItem asks the item provider to provide us with its item (code executes asynchronously since code uses closure)
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }

                    self?.pageTitle = javaScriptValues["title]"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.load()
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @objc func chooseScript() {
        let ac = UIAlertController(title: "Choose script to run", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "alert()", style: .default) {
            [weak self] _ in
            self?.script.text = "alert(document.title);"
            self?.save()
        })
        ac.addAction(UIAlertAction(title: "prompt()", style: .default) {
            [weak self] _ in
            self?.script.text = """
                let person = prompt(\"Please enter your name\", \"Harry Potter\");
                alert(\"Hello \" + person + \"! How are you today?\");
                """
            self?.save()
        })
        ac.addAction(UIAlertAction(title: "open()", style: .default) {
            [weak self] _ in
            self?.script.text = "window.open(\"https://old.reddit.com\");"
            self?.save()
        })
        ac.addAction(UIAlertAction(title: "scrollBy()", style: .default) {
            [weak self] _ in
            self?.script.text = "window.scrollBy(0, 1000);\nalert(\"Scrolled \" + window.scrollX + \" pixels to the right and \" + window.scrollY + \" pixels down.\")"
            self?.save()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    @IBAction func done() {
        // reverses what was done in viewDidLoad()
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // gives us the size of the keyboard
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return } // UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating. Will be of type NSValue, which is of type CGRect (a CGRect struct holds both CGPoint and CGSize)
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        save()
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let site = URL(string: pageURL)

        if let savedJS = defaults.object(forKey: site?.host ?? "site") as? Data {
            do {
                script.text = try JSONDecoder().decode(String.self, from: savedJS)
            } catch {
                print("Failed to load JavaScript")
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        // converts string URL to URL and utilizes URL object host property as forKey
        let site = URL(string: pageURL)
        
        if let savedJS = try? JSONEncoder().encode(script.text) {
            // saves user's JavaScript for each site by making forKey unique to host
            defaults.set(savedJS, forKey: site?.host ?? "site")
        } else {
            print("Failed to save JavaScript")
        }
    }
}
