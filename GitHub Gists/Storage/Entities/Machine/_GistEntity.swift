// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GistEntity.swift instead.

import Foundation
import CoreData

public enum GistEntityAttributes: String {
    case comments = "comments"
    case commentsUrl = "commentsUrl"
    case commitsUrl = "commitsUrl"
    case createdAt = "createdAt"
    case forksUrl = "forksUrl"
    case gistsDescription = "gistsDescription"
    case gitPullUrl = "gitPullUrl"
    case gitPushUrl = "gitPushUrl"
    case htmlUrl = "htmlUrl"
    case id = "id"
    case isPublic = "isPublic"
    case nodeId = "nodeId"
    case order = "order"
    case updatedAt = "updatedAt"
    case url = "url"
    case username = "username"
}

public enum GistEntityRelationships: String {
    case files = "files"
}

open class _GistEntity: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "GistEntity"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _GistEntity.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var comments: NSNumber?

    @NSManaged open
    var commentsUrl: String?

    @NSManaged open
    var commitsUrl: String?

    @NSManaged open
    var createdAt: Date?

    @NSManaged open
    var forksUrl: String?

    @NSManaged open
    var gistsDescription: String?

    @NSManaged open
    var gitPullUrl: String?

    @NSManaged open
    var gitPushUrl: String?

    @NSManaged open
    var htmlUrl: String?

    @NSManaged open
    var id: String

    @NSManaged open
    var isPublic: NSNumber?

    @NSManaged open
    var nodeId: String?

    @NSManaged open
    var order: NSNumber?

    @NSManaged open
    var updatedAt: Date?

    @NSManaged open
    var url: String?

    @NSManaged open
    var username: String

    // MARK: - Relationships

    @NSManaged open
    var files: NSSet

    open func filesSet() -> NSMutableSet {
        return self.files.mutableCopy() as! NSMutableSet
    }

}

extension _GistEntity {

    open func addFiles(_ objects: NSSet) {
        let mutable = self.files.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.files = mutable.copy() as! NSSet
    }

    open func removeFiles(_ objects: NSSet) {
        let mutable = self.files.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.files = mutable.copy() as! NSSet
    }

    open func addFilesObject(_ value: GistFileEntity) {
        let mutable = self.files.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.files = mutable.copy() as! NSSet
    }

    open func removeFilesObject(_ value: GistFileEntity) {
        let mutable = self.files.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.files = mutable.copy() as! NSSet
    }

}

