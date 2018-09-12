//
//  RSSChannel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 23.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import EVReflection

class RSSChannel: EVObject {
    
    public var title: String?
    
    public var sourceDescription: String?
    
    public var lastBuildDate: String?
    
    public var image: RSSImage?
    
    public var link: String?
    
    public var item: [RSSItem]? = []
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)]
    {
        return [(keyInObject: "sourceDescription", keyInResource: "description")]
    }
}
