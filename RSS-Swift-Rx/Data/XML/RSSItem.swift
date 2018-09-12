//
//  RSSItem.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 23.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import EVReflection

class RSSItem: EVObject {
    
    public var guid: String?
    
    public var title: String?
    
    public var pubDate: String?
    
    public var itemDescription: String?
    
    public var link: String?
    
    public var author: String?
    
    public var category: [String]?
    
    public var comments: String?
        
    public var source: String?
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)]
    {
        return [(keyInObject: "itemDescription", keyInResource: "description")]
    }
}
