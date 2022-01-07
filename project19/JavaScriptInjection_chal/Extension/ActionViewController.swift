//
//  ActionViewController.swift
//  Extension
//
//  Created by Arvin Shen on 1/5/22.
//

import UIKit
import MobileCoreServices

protocol ActionViewControllerDelegate: NSObjectProtocol {
    func passDataBackToTableView(data: String, index: Int)
}

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    weak var delegate: ActionViewControllerDelegate?

    var scripts = [Script]()
    var index = 0
    var javaScript = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        script.text = javaScript
        
        navigationItem.leftItemsSupplementBackButton = true
        
        let chooseScriptBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseScript))
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItems = [chooseScriptBtn, saveBtn]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func chooseScript() {
        let ac = UIAlertController(title: "Choose a pre-written example script to run", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "alert()", style: .default) {
            [weak self] _ in
            self?.script.text = "alert(document.title);"
        })
        ac.addAction(UIAlertAction(title: "prompt()", style: .default) {
            [weak self] _ in
            self?.script.text = """
                let person = prompt(\"Please enter your name\", \"Harry Potter\");
                alert(\"Hello \" + person + \"! How are you today?\");
                """
        })
        ac.addAction(UIAlertAction(title: "open()", style: .default) {
            [weak self] _ in
            self?.script.text = "window.open(\"https://old.reddit.com\");"
        })
        ac.addAction(UIAlertAction(title: "scrollBy()", style: .default) {
            [weak self] _ in
            self?.script.text = "window.scrollBy(0, 1000);\nalert(\"Scrolled \" + window.scrollX + \" pixels to the right and \" + window.scrollY + \" pixels down.\")"
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
    }
    
    @objc func save() {
        // passes back script text back to Table View (ViewController)
        if let delegate = delegate {
            delegate.passDataBackToTableView(data: script.text, index: index)
        }
    }
}
