//
//  FRCSectionsSource.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 16.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import CoreData

class FRCSectionsSource<Entity>: NSObject, SectionsSource, NSFetchedResultsControllerDelegate
    where Entity: NSManagedObject
{
    private let frc: NSFetchedResultsController<Entity>
    
    init(frc: NSFetchedResultsController<Entity>) {
        self.frc = frc
        super.init()
        self.frc.delegate = self
    }
    
    var delegate: SectionsSourceDelegate?
    
    func numberOfSections() -> Int {
        return frc.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    func entity(at indexPath: IndexPath) -> Entity
    {
        return frc.object(at: indexPath)
    }

    // NSFetchedResultsControllerDelegate
    
    private var updates: [SectionsSourceUpdate]?
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        updates = [SectionsSourceUpdate]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            updates?.append(.InsertItems([newIndexPath!]))
            
        case .delete:
            updates?.append(.DeleteItems([indexPath!]))
            
        case .move:
            updates?.append(.MoveItem(indexPath!, newIndexPath!))
            
        case .update:
            updates?.append(.UpdateItems([indexPath!]))
        }
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert:
            updates?.append(.InsertSections(IndexSet(integer: sectionIndex)))
            
        case .delete:
            updates?.append(.DeleteSections(IndexSet(integer: sectionIndex)))
            
        case .update, .move:
            updates?.append(.UpdateSections(IndexSet(integer: sectionIndex)))
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        if let updates = self.updates {
            delegate?.sectionsSource(self, didUpdate: updates)
        }
        updates = nil
    }
}

