//
//  WebviewCell.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import UIKit
import WebKit

class WebviewCell: UICollectionViewCell {
    static let reuseId = "webviewCell"
    static let nibName = "WebviewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureWebView(webview: WKWebView) {
        self.addSubview(webview)
        webview.backgroundColor = .clear
        webview.isOpaque = false
        webview.scrollView.backgroundColor = .clear
        webview.scrollView.isScrollEnabled = false
        webview.autoresizingMask = .flexibleHeight
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        webview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        webview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        webview.scrollView.delegate = self
    }

}

extension WebviewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
