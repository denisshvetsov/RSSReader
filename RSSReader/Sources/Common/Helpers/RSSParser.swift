//
//  RSSParser.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

struct RSSItem {
    var title: String = ""
    var link: String = ""
    var desc: String = ""
    var date: String = ""
}

struct RSSFeed {
    var title = ""
    var items: [RSSItem] = []
}

class RSSParser: NSObject, XMLParserDelegate {
    
    var parser: XMLParser!
    
    var feed = RSSFeed()
    
    private var item = RSSItem()
    private var foundCharacters = ""
    
    init(data: Data) {
        super.init()
        self.parser = XMLParser(data: data)
        self.parser.delegate = self
    }
    
    func parse() -> Bool {
        return self.parser.parse()
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "title" && self.feed.title.isEmpty {
            self.feed.title = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if elementName == "title" && !self.feed.title.isEmpty {
            self.item.title = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if elementName == "link" {
            self.item.link = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if elementName == "description" {
            self.item.desc = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if elementName == "pubDate" {
            self.item.date = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if elementName == "item" {
            let tempItem = RSSItem(title: self.item.title,
                                   link: self.item.link,
                                   desc: self.item.desc,
                                   date: self.item.date)
            self.feed.items.append(tempItem)
        }
        self.foundCharacters = ""
    }

}












