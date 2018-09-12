// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NewsEntity.swift instead.

import Foundation
import CoreData

public enum NewsEntityAttributes: String {
    case author = "author"
    case categoryTransform = "categoryTransform"
    case comments = "comments"
    case guid = "guid"
    case isHtmlNumber = "isHtmlNumber"
    case linkString = "linkString"
    case newsDescription = "newsDescription"
    case pubDate = "pubDate"
    case title = "title"
}

public enum NewsEntityRelationships: String {
    case source = "source"
}

open class _NewsEntity: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "NewsEntity"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _NewsEntity.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var author: String?

    @NSManaged open
    var categoryTransform: AnyObject?

    @NSManaged open
    var comments: String?

    @NSManaged open
    var guid: String?

    @NSManaged open
    var isHtmlNumber: NSNumber?

    @NSManaged open
    var linkString: String?

    @NSManaged open
    var newsDescription: String?

    @NSManaged open
    var pubDate: Date?

    @NSManaged open
    var title: String?

    // MARK: - Relationships

    @NSManaged open
    var source: NewsSourceEntity?

}

