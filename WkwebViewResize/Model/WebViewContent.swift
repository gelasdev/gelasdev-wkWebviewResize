//
//  WebViewContent.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import Foundation
import WebKit

class WebViewContent {
    public var contentHTML: String
    public var height: CGFloat
    public var webView = WKWebView(frame: .zero)
    
    public init(contentHTML: String, height: CGFloat, uDelegate: WKUIDelegate, nDelegate: WKNavigationDelegate) {
        self.contentHTML = contentHTML
        self.height = height
        webView.uiDelegate = uDelegate
        webView.navigationDelegate = nDelegate
        webView.loadHTMLString(contentHTML, baseURL: nil)
    }
}
