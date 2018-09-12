//
//  SectionsSource.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 16.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

protocol SectionsSource: AnyObject
{
    var delegate: SectionsSourceDelegate? { get set }
    
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
}

enum SectionsSourceUpdate {
    case Reload
    
    case InsertSections(IndexSet)
    case DeleteSections(IndexSet)
    case UpdateSections(IndexSet)
    case MoveSection(Int, Int)
    
    case InsertItems([IndexPath])
    case DeleteItems([IndexPath])
    case UpdateItems([IndexPath])
    case MoveItem(IndexPath, IndexPath)
}

protocol SectionsSourceDelegate: class
{
    func sectionsSource(_ sectionsSource: SectionsSource, didUpdate updates: [SectionsSourceUpdate])
}

