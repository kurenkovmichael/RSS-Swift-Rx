//
//  NewsSourceModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift
import MagicalRecord

import XMLDictionary
import EVReflection

class NewsSourceModel: NSObject
{
    public func loadNewsSource(url: URL) -> Observable<Void>
    {
        let request = URLRequest.init(url: url)
        return URLSession.shared.rx.data(request: request)
            .map({ (data) -> RSS? in
                return RSS.init(xmlData: data)
            }).do(onNext: { (result) in
                guard let rss = result else {
                    return
                }
                guard let channel = rss.channel else {
                    return
                }
                
                MagicalRecord.save({ (context) in
                    
                    let df = DateFormatter()
                    df.locale = Locale(identifier: "en_US_POSIX")
                    df.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                    df.timeZone = TimeZone(secondsFromGMT: 0)
                    df.dateFormat = "dd MMM yyyy HH:mm:ss ZZZZ"
                    
                    let newsSourceEntity = NewsSourceEntity.mr_findFirst(with: NSPredicate(format: "linkString == %@", url.absoluteString),
                                                                         in: context) as! NewsSourceEntity
                    
                    newsSourceEntity.title = channel.title
                    newsSourceEntity.sourceDescription = channel.sourceDescription
                    newsSourceEntity.imageUrlString = channel.image?.url
                    
                    var searchTerm = newsSourceEntity.link.absoluteString
                    if let title = channel.title {
                        searchTerm = searchTerm.appendingFormat("|%@", title)
                    }
                    if let sourceDescription = channel.sourceDescription {
                        searchTerm = searchTerm.appendingFormat("|%@", sourceDescription)
                    }
                    newsSourceEntity.searchTerm = searchTerm
                    
                    if let lastBuildDate = channel.lastBuildDate {
                        newsSourceEntity.lastBuildDate = df.date(from: lastBuildDate)
                    }
                    
                    newsSourceEntity.items = []
                    
                    if let items = channel.item {
                        for item in items {
                            let newsEntity = NewsEntity.mr_create(in: context) as! NewsEntity
                            
                            newsEntity.guid            = item.guid
                            newsEntity.title           = item.title
                            newsEntity.newsDescription = item.itemDescription
                            newsEntity.linkString      = item.link
                            newsEntity.author          = item.author
                            newsEntity.category        = item.category
                            newsEntity.comments        = item.comments
                            
                            newsEntity.isHtml = false;
                            
                            if let pubDate = item.pubDate {
                                newsEntity.pubDate = df.date(from: pubDate)
                            }
                            
                            newsEntity.source = newsSourceEntity
                        }
                    }
                })
            }).map {_ in }
    }
    
    public func deleteNewsSource(url: URL)
    {
        MagicalRecord.save({ (context) in
            let newsSourceEntities = NewsSourceEntity.mr_findAll(with: NSPredicate(format: "linkString == %@", url.absoluteString),
                                                                 in: context) as! [NewsSourceEntity]
            for newsSourceEntity in newsSourceEntities {
                newsSourceEntity.mr_delete(in: context)
            }
        })
    }
    
    private func containsHtml(str: String) -> Bool
    {
//        do {
////            let pattern = "(?i)<td[^>]*>" // <\/?[\w\s="/.':;#-\/\?]+>
//            let pattern = "<\/?[\w\s="/.':;#-\/\?]+>"
//            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
//            let matches = regex.matches(in: str, options: .withoutAnchoringBounds, range: NSMakeRange(0, str.count))
//            return matches.count > 0
//        } catch {
            return false
//        }
    }
}
