import Foundation
import CoreData

@objc(GistEntity)
open class GistEntity: _GistEntity {

    // MARK: Predicates
    static func predicate(with username: String) -> NSPredicate {
        return NSPredicate(format: "username == %@", username)
    }

    static func predicate(with username: String, gistId: String) -> NSPredicate {
        return NSPredicate(format: "username == %@ AND id == %@", username, gistId)
    }

    // MARK: Actions

    static func find(with username: String, gistId: String,
                     in context: NSManagedObjectContext?) -> GistEntity? {
        let predicate = GistEntity.predicate(with: username, gistId: gistId)
        return GistEntity.mr_findFirst(with: predicate, in: context) as? GistEntity
    }

    static func findOrCreate(with username: String,
                             gistId: String,
                             in context: NSManagedObjectContext?) -> GistEntity? {
        let foundGist = find(with: username, gistId: gistId, in: context)
        if let foundGist = foundGist {
            return foundGist
        }

        if let createdGist = GistEntity.mr_create(in: context) as? GistEntity {
            createdGist.id = gistId
            createdGist.username = username

            let maxOrder = GistEntity.fingMaxOrder(withUsername: username, in: context)
            createdGist.order = NSNumber(value: maxOrder + 1)
            return createdGist
        }

        return nil
    }

    static func delete(with username: String,
                       exclusionGistsWithIds exclusionIds: [String],
                       in context: NSManagedObjectContext?) {
        let predicate = NSPredicate(format: "username == %@ AND NOT (id IN %@)",
                                    username, exclusionIds)
        GistEntity.mr_deleteAll(matching: predicate, in: context)
    }

    func fill(from gist: Gist) {
        id = gist.gistId

        nodeId = gist.nodeId
        gistsDescription = gist.gistsDescription
        isPublic = NSNumber(value: gist.isPublic)
        createdAt = gist.createdAt
        updatedAt = gist.updatedAt
        url = gist.url
        forksUrl = gist.forksUrl
        commitsUrl = gist.commitsUrl
        gitPullUrl = gist.gitPullUrl
        gitPushUrl = gist.gitPushUrl
        htmlUrl = gist.htmlUrl
        comments = NSNumber(value: gist.comments)
        commentsUrl = gist.commentsUrl
    }

    // MARK: Private

    private static func fingMaxOrder(withUsername username: String, in context: NSManagedObjectContext?) -> Int {
        let predicate = GistEntity.predicate(with: username)
        let gistEntity = GistEntity.mr_findFirst(with: predicate,
                                                 sortedBy: "order",
                                                 ascending: false,
                                                 in: context) as? GistEntity
        return gistEntity?.order?.intValue ?? 0
    }

}
