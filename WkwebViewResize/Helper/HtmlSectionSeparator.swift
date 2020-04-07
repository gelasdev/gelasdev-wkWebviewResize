//
//  HtmlSectionSeparator.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import Foundation

class HtmlSectionSeparator {
    private var fontSize: Int = 18
    private var textColor: String = "#000000"
    
    init(fontSize: Int, textColor: String) {
        self.fontSize = fontSize
        self.textColor = textColor
    }

    func getSectionsFromHtmlString(_ html: String) -> [String] {
        
        let paragraphs = getParagraphs(html: html)
        var htmlStringArray: [String] = []
        
        for index in 0..<paragraphs.count {
            
            let htmlString = "<div id='foo'>" + "<span style=\"color: \(textColor); font-size: \(fontSize)\">\(paragraphs[index])</span>" + "<head> <style> a { color: \(textColor); } </style> </head> <meta name=\"format-detection" + "content=\"telephone=no>" + "</div>"
            
            htmlStringArray.insert(htmlString, at: index)
            
        }
        
        return htmlStringArray
    }
    
    func getParagraphs(html: String) -> [String] {
        
        var paragraphs: [String] = []
        let trimmedHtml = trimHtml(html: html)
        
        var minimumIndex: String.Index?
        let seperators = ["<p>", "</p>", "<br>", "</br>", "<br/>", "<br />"]
        for seperator in seperators {
            
            if let offset = trimmedHtml.range(of: seperator) {
                
                if minimumIndex == nil {
                    minimumIndex = offset.lowerBound
                } else {
                    
                    if minimumIndex! > offset.lowerBound {
                        minimumIndex = offset.lowerBound
                    }
                }
            }
        }
        
        if minimumIndex != nil {
            
            paragraphs.append(trimHtml(html: String(trimmedHtml[..<minimumIndex!])))
            paragraphs.append(trimHtml(html: String(trimmedHtml[minimumIndex!...])))
            return paragraphs
        }
        
        paragraphs.append(html)
        return paragraphs
    }
    
    func trimHtml(html: String) -> String {
        
        var trimmedHtml = html.trimmingCharacters(in: .whitespacesAndNewlines)
        while (trimmedHtml.first == "<") {
            // remove tags at the start of string
            if let endOffset = trimmedHtml.range(of: ">") {
                trimmedHtml = String(trimmedHtml[endOffset.upperBound...])
                trimmedHtml = trimmedHtml.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return trimmedHtml
        
    }
}
