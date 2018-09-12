// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NewsSourceEntity.swift instead.

import Foundation
import CoreData

public enum NewsSourceEntityAttributes: String {
    case imageLinkString = "imageLinkString"
    case imageUrlString = "imageUrlString"
    case lastBuildDate = "lastBuildDate"
    case linkString = "linkString"
    case order = "order"
    case searchTerm = "searchTerm"
    case sourceDescription = "sourceDescription"
    case title = "title"
}

public enum NewsSourceEntityRelationships: String {
    case items = "items"
}

open class _NewsSourceEntity: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "NewsSourceEntity"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _NewsSourceEntity.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var imageLinkString: String?

    @NSManaged open
    var imageUrlString: String?

    @NSManaged open
    var lastBuildDate: Date?

    @NSManaged open
    var linkString: String

    @NSManaged open
    var order: NSNumber?

    @NSManaged open
    var searchTerm: String?

    @NSManaged open
    var sourceDescription: String?

    @NSManaged open
    var title: String?

    // MARK: - Relationships

    @NSManaged open
    var items: NSSet

    open func itemsSet() -> NSMutableSet {
        return self.items.mutableCopy() as! NSMutableSet
    }

}

extension _NewsSourceEntity {

    open func addItems(_ objects: NSSet) {
        let mutable = self.items.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.items = mutable.copy() as! NSSet
    }

    open func removeItems(_ objects: NSSet) {
        let mutable = self.items.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.items = mutable.copy() as! NSSet
    }

    open func addItemsObject(_ value: NewsEntity) {
        let mutable = self.items.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.items = mutable.copy() as! NSSet
    }

    open func removeItemsObject(_ value: NewsEntity) {
        let mutable = self.items.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.items = mutable.copy() as! NSSet
    }

}

