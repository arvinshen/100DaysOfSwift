//
//  WebViewController.swift
//  CapitalCities
//
//  Created by Arvin Shen on 1/2/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedCapital: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let city = selectedCapital {
            if let url = URL(string: "https://en.wikipedia.org/wiki/\(city)") {
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
            }
        }
    }
}
