//
//  DetailViewController.swift
//  CountryDB
//
//  Created by Arvin Shen on 1/3/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Country?
    var languageList = ""
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        if detailItem.languages.count > 0 {
            languageList += "<ul>"
            for language in detailItem.languages {
                languageList += "<li>\(language)</li>"
            }
            languageList += "</ul"
        } else {
            languageList = "None"
        }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <h1>\(detailItem.country) (\(detailItem.abbreviation))</h1>
        <h3>Capital: \(detailItem.city ?? "N/A")</h3>
        <p1>
            Population: \(detailItem.population)<br>
            Languages: \(languageList)
        </p1>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
