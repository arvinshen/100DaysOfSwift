//
//  ViewController.swift
//  WebBrowser
//
//  Created by Arvin Shen on 11/16/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var selectedWebsite: String?
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
            webView = WKWebView()
            webView.navigationDelegate = self
            view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedWebsite
        navigationItem.largeTitleDisplayMode = .never
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
//        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url:url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if host.contains(selectedWebsite!) {
                decisionHandler(.allow)
                return
            }
        }
        let ac = UIAlertController(title: "URL blocked!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        if webView.isLoading == false {
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }
}

