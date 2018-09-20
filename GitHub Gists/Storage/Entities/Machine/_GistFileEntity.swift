// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GistFileEntity.swift instead.

import Foundation
import CoreData

public enum GistFileEntityAttributes: String {
    case content = "content"
    case filename = "filename"
    case language = "language"
    case order = "order"
    case rawUrl = "rawUrl"
    case size = "size"
    case type = "type"
}

public enum GistFileEntityRelationships: String {
    case gist = "gist"
}

open class _GistFileEntity: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "GistFileEntity"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _GistFileEntity.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var content: String?

    @NSManaged open
    var filename: String

    @NSManaged open
    var language: String?

    @NSManaged open
    var order: NSNumber?

    @NSManaged open
    var rawUrl: String?

    @NSManaged open
    var size: NSNumber?

    @NSManaged open
    var type: String?

    // MARK: - Relationships

    @NSManaged open
    var gist: GistEntity?

}

