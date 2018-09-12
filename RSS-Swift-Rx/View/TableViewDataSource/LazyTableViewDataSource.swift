//
//  LazyTableViewDataSource.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 16.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import Foundation
import UIKit

class LazyTableViewDataSource<S: SectionsSource> : NSObject, UITableViewDataSource, UITableViewDelegate
{
    public weak var tableView: UITableView? {
        willSet {
            tableView?.dataSource = nil
            tableView?.delegate = nil
        }
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            
            tableView?.reloadData()
        }
    }
    
    init(source:        S,
         configureCell: @escaping ConfigureCell<S>)
    {
        self.source        = source;
        self.configureCell = configureCell
        
        super.init()
        self.source.delegate = self
    }

    let source:            S
    let configureCell:     ConfigureCell<S>
    var didSelect:         DidSelect<S>?
    var editActionsForRow: EditActionsForRow<S>?
    var canEditRow:        CanEditRow<S>?
    var canMoveRow:        CanEditRow<S>?
    var moveRow:           MoveRow<S>?
    
    // UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return source.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return source.numberOfItemsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return configureCell(source, tableView, indexPath)
    }
    
    // UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let didSelect = self.didSelect {
            didSelect(source, tableView, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]?
    {
        if let editActionsForRow = self.editActionsForRow {
            return editActionsForRow(source, editActionsForRowAt)
            
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if let canEditRow = self.canEditRow {
            return canEditRow(source, indexPath)
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        if let canMoveRow = self.canMoveRow {
            return canMoveRow(source, indexPath)
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if let moveRow = self.moveRow {
            moveRow(source, sourceIndexPath, destinationIndexPath)
        }
    }
}

extension LazyTableViewDataSource
{
    public typealias ConfigureCell<S>     = (S, UITableView, IndexPath) -> UITableViewCell
    public typealias DidSelect<S>         = (S, UITableView, IndexPath) -> Void
    public typealias EditActionsForRow<S> = (S, IndexPath) -> [UITableViewRowAction]
    public typealias CanEditRow<S>        = (S, IndexPath) -> Bool
    public typealias CanMoveRow<S>        = (S, IndexPath) -> Bool
    public typealias MoveRow<S>           = (S, IndexPath, IndexPath) -> Void
}

extension LazyTableViewDataSource: SectionsSourceDelegate
{
    func sectionsSource(_ sectionsSource: SectionsSource, didUpdate updates: [SectionsSourceUpdate])
    {
        guard let tableView = self.tableView else {
            return
        }
        
        tableView.beginUpdates()
        
        for update in updates {
            switch update {
            case .Reload:
                tableView.reloadData()
                
            case .InsertSections(let sections):
                tableView.insertSections(sections, with: .fade)
                
            case .DeleteSections(let sections):
                tableView.deleteSections(sections, with: .fade)
                
            case .UpdateSections(let sections):
                tableView.reloadSections(sections, with: .fade)
                
            case .MoveSection(let fromSection, let toSection):
                tableView.moveSection(fromSection, toSection: toSection)
                
            case .InsertItems(let indexPaths):
                tableView.insertRows(at: indexPaths, with: .fade)
                
            case .DeleteItems(let indexPaths):
                tableView.deleteRows(at: indexPaths, with: .fade)
                
            case .UpdateItems(let indexPaths):
                tableView.reloadRows(at: indexPaths, with: .none)
                
            case .MoveItem(let fromIndexPath, let toIndexPath):
                tableView.moveRow(at: fromIndexPath, to: toIndexPath)
            }
        }
        
        tableView.endUpdates()
    }
}
