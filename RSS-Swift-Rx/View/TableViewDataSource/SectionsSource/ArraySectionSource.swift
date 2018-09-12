//
//  ArraySectionSource.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 17.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

class ArraySectionSource<Item>: SectionsSource
{
    private let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    var delegate: SectionsSourceDelegate?
    
    func numberOfSections() -> Int {
        return items.count > 0 ? 1 : 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return items.count
    }
    
    func itemAt(index: Int) -> Item
    {
        return items[index]
    }
}
