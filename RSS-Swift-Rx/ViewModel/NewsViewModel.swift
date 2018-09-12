//
//  NewsViewModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift

class NewsViewModel: NSObject {
    
    public let entity: NewsEntity
    
    init(entity: NewsEntity) {
        self.entity = entity;
    }
    
    public var link: URL? {
        return entity.link
    }
    
    public var title: String? {
        return entity.title
    }
    
    public var newsDescription: String? {
        return entity.newsDescription
    }
    
    public var guid: String? {
        return entity.guid
    }
    
    public var pubDate: Date?  {
        return entity.pubDate
    }

    public var author: String? {
        return entity.author
    }
    
    public var isHtml: Bool {
        return entity.isHtml
    }
}
