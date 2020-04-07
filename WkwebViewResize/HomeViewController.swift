//
//  HomeViewController.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import UIKit
import WebKit
class HomeViewController: UIViewController {
    var dataSource: [Any] = []
    var fontSize: Int = 13
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fontSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        seperateHtml()
    }
    
    private func setupCollectionView() {
        let webViewCellNib = UINib(nibName: WebviewCell.nibName, bundle: nil)
        let adCellNib = UINib(nibName: AdCell.nibName, bundle: nil)
        collectionView.register(webViewCellNib, forCellWithReuseIdentifier: WebviewCell.reuseId)
        collectionView.register(adCellNib, forCellWithReuseIdentifier: AdCell.reuseId)
    }
    
    private func fetchData() -> MyTestDataModel? {
        if let path = Bundle.main.path(forResource: "myTestData", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return try JSONDecoder().decode(MyTestDataModel.self, from: data)
                
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    private func seperateHtml() {
        let seperator = HtmlSectionSeparator(fontSize: 13, textColor: "#000000")
        guard let htmlData = fetchData() else { return }
        let htmls = seperator.getSectionsFromHtmlString(htmlData.text)
        htmls.forEach { (htmlString) in
            let webContent = WebViewContent(contentHTML: htmlString, height: 0, uDelegate: self, nDelegate: self)
            dataSource.append(webContent)
        }
        collectionView.reloadData()
    }
    
    private func changeFont(fontSize: Int) {
        let javascriptString = "document.getElementsByTagName('span')[0].style.fontSize='\(fontSize)px'"
        dataSource.compactMap { $0 as? WebViewContent }
            .forEach { $0.webView.evaluateJavaScript(javascriptString) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                }}
    }
    
    private func calculateWebViewHeight() {
        dataSource.forEach { (content) in
            guard let webViewContent = content as? WebViewContent else { return }
            webViewContent.webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                webViewContent.height = height as! CGFloat
            })
        }
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func fontSliderValueChanged(_ sender: UISlider) {
        let roundedFontSize = Int(roundf(sender.value))
        if fontSize != roundedFontSize {
            fontSize = roundedFontSize
            changeFont(fontSize: fontSize)
            calculateWebViewHeight()
        }
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let content = dataSource[indexPath.item]
        
        if let webViewContent = content as? WebViewContent {
            let webCell = collectionView.dequeueReusableCell(withReuseIdentifier: WebviewCell.reuseId, for: indexPath) as! WebviewCell
            webCell.configureWebView(webview: webViewContent.webView)
            webViewContent.webView.tag = indexPath.row
            webCell.backgroundColor = .red
            return webCell
        } else {
            let adCell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCell.reuseId, for: indexPath) as! AdCell
            return adCell
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let content = dataSource[indexPath.row]
        if let webContent = content as? WebViewContent {
            return .init(width: self.view.frame.width, height: webContent.height)
        } else {
            return .init(width: self.view.frame.width, height: 100)
        }
    }
}


extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dataSource.forEach { (webViewContent) in
            guard let webviewContent = webViewContent as? WebViewContent else { return }
            if webviewContent.webView.tag == webView.tag {
                webView.contentSize { (size, error) in
                    webviewContent.height = size?.height ?? 0.00
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
    }
}

extension HomeViewController: WKUIDelegate {
    
}

extension WKWebView {
    
    func contentSize(completion : @escaping (_ size: CGSize?, _ error: Error?) -> ()){
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"

        self.evaluateJavaScript(scriptContent, completionHandler: nil)
        self.evaluateJavaScript("document.body.scrollHeight;") { (scrollHeight, error) in
            if let height = scrollHeight as? CGFloat {
                self.evaluateJavaScript("document.body.scrollWidth;") { (scrollWidth, error) in
                    if let width = scrollWidth as? CGFloat {
                        let sizeThatFits = self.sizeThatFits(.zero)
                        let widthPercentage = (width / sizeThatFits.width) * 100
                        let requiredHeight = (height / widthPercentage) * 100
                        let size = CGSize.init(width: sizeThatFits.width, height: requiredHeight)
                        completion(size, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
}
