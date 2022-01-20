//
//  AddNoteController.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import UIKit

protocol AddNoteControllerDelegate: NSObjectProtocol {
    func passDataBackToNotesController(header: String, body: String, text: String, index: Int)
}

class AddNoteController: UIViewController, UITextViewDelegate {
    weak var delegate: AddNoteControllerDelegate?
    var notes = [Note]()
    var header = ""
    var body = ""
    var index = 0
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.allowsEditingTextAttributes = true
        tv.textColor = .black
        tv.font = UIFont(name: "Helvetica-bold", size: 32.0)
        tv.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return tv
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.configureAttributedText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        if textView.text.isEmpty {
            textView.becomeFirstResponder()
        }
        textView.delegate = self
        textView.configureAttributedText()
    }

    // MARK: - Selectors
    @objc func done() {
        view.endEditing(true)
        save()
    }
    
    func save() {
        // passes note text back to NotesController Table View
        if let delegate = delegate {
            if !textView.text.contains("\n") {
                delegate.passDataBackToNotesController(header: textView.text, body: "", text: textView.text, index: index)
                return
            }
            let textToSplit: [String.SubSequence]
            let justLineBreaks = textView.text.replacingOccurrences(of: "\n", with: "")
            if !justLineBreaks.isEmpty {
                textToSplit = textView.text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
                header = String(textToSplit[0])
                body = String(textToSplit[1])
            } else {
                textToSplit = [String.SubSequence(justLineBreaks)]
                header = String(textToSplit[0])
                body = String(textToSplit[0])
            }

            delegate.passDataBackToNotesController(header: header, body: body, text: textView.text, index: index)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // get size of keyboard
        guard let keyboardValue = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating. Will be of type NSValue, which is of type CGRect, which is a struct that holds both CGPoint and CGSize.
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            textView.textContainerInset = UIEdgeInsets(top: 00, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height ?? 0), right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.textContainerInset
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }


    // MARK: - Tool Bar Controller
//    [checkmark.circle, camera, pencil.tip.crop.circle, square.and.pencil]
//    folder.badge.plus // in folders view controller
    
}

extension UITextView {
    func configureAttributedText() {
        let cursorPosition = self.selectedRange
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
        
        let text = self.text! as NSString
        let textRange = text.range(of: self.text)
        
        print(cursorPosition)
        print(text)
        if text == "" || !text.contains("\n") {
            let boldFont = UIFont(name: "Helvetica-bold", size: 32.0) as Any
            
            attributedText.addAttribute(NSAttributedString.Key.font, value: boldFont, range: textRange)
        } else {
            self.font = UIFont(name: "Helvetica", size: 16.0)
            let textToSplit: [String.SubSequence]
            let justLineBreaks = text.replacingOccurrences(of: "\n", with: "")
            if !justLineBreaks.isEmpty {
                textToSplit = self.text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
            } else {
                textToSplit = [String.SubSequence(justLineBreaks)]
            }
            attributedText.addAttribute(NSAttributedString.Key.font, value: self.font!, range: textRange)
            
            let boldRange = text.range(of: String(textToSplit[0]))
            let boldFont = UIFont(name: "Helvetica-bold", size: 32.0) as Any
            
            attributedText.addAttribute(NSAttributedString.Key.font, value: boldFont, range: boldRange)
        }
        self.attributedText = attributedText
        
        self.selectedRange = cursorPosition
    }
}
