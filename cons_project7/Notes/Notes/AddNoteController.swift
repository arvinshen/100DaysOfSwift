//
//  AddNoteController.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import UIKit

class AddNoteController: UIViewController {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        textView.becomeFirstResponder()
    }

    // MARK: - Selectors
    
    @objc func handleDone() {
        print("Handle done...")
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // get size of keyboard
        guard let keyboardValue = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating. Will be of type NSValue, which is of type CGRect, which is a struct that holds both CGPoint and CGSize.
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height)!, right: 20)
//            textView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height)!, right: 15)
        } else {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height)!, right: 20)
//            textView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (navigationController?.tabBarController?.tabBar.frame.size.height)!, right: 15)
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
