//
//  AddNoteController.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import UIKit

protocol AddNoteControllerDelegate: NSObjectProtocol {
    func passDataBackToNotesController(data: String, index: Int)
}

class AddNoteController: UIViewController {
    weak var delegate: AddNoteControllerDelegate?
    var notes = [Note]()
    var index = 0
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.allowsEditingTextAttributes = true
        tv.textColor = .black
        return tv
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.layer.borderColor = UIColor.clear.cgColor

        view.backgroundColor = .white
        
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
        
        textView.becomeFirstResponder()
    }

    // MARK: - Selectors
    @objc func done() {
        view.endEditing(true)
        save()
    }
    
    func save() {
        // passes note text back to NotesController Table View
        if let delegate = delegate {
            delegate.passDataBackToNotesController(data: textView.text, index: index)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // get size of keyboard
        guard let keyboardValue = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating. Will be of type NSValue, which is of type CGRect, which is a struct that holds both CGPoint and CGSize.
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height ?? 0), right: 20)
        }
        
        textView.scrollIndicatorInsets = textView.textContainerInset
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }

    // MARK: - Tab Bar Controller
//    [checkmark.circle, camera, pencil.tip.crop.circle, square.and.pencil]
//    folder.badge.plus // in folders view controller
    
}
