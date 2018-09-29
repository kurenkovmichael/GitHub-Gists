import Foundation
import CoreData

@objc(GistFileEntity)
open class GistFileEntity: _GistFileEntity {

    // MARK: Predicates

    static func predicate(with filename: String, gist: GistEntity) -> NSPredicate {
        return NSPredicate(format: "gist == %@ AND filename == %@", gist.objectID, filename)
    }

    static func predicate(with gistId: String) -> NSPredicate {
        return NSPredicate(format: "gist.id == %@", gistId)
    }

    static func predicate(withGistId gistId: String, filename: String) -> NSPredicate {
        return NSPredicate(format: "gist.id == %@ AND filename == %@", gistId, filename)
    }

    // MARK: Actions

    static func findOrCreate(with filename: String,
                             gist: GistEntity,
                             in context: NSManagedObjectContext?) -> GistFileEntity {
        let predicate = GistFileEntity.predicate(with: filename, gist: gist)
        var fileEntity = GistFileEntity.mr_findFirst(with: predicate, in: context)
            as? GistFileEntity

        if fileEntity == nil {
            fileEntity = GistFileEntity.mr_create(in: context) as? GistFileEntity
            fileEntity!.filename = filename

            let maxOrder = GistFileEntity.fingMaxOrder(withFilename: filename, gist: gist, in: context)
            fileEntity!.order = NSNumber(value: maxOrder + 1)

            gist.addFilesObject(fileEntity!)
        }
        return fileEntity!
    }

    static func delete(from gist: GistEntity,
                       exclusionFilesWithNames exclusionFileNames: [String],
                       in context: NSManagedObjectContext?) {
        let predicate = NSPredicate(format: "gist == %@ AND NOT (filename IN %@)",
                                    gist.objectID, exclusionFileNames)
        GistFileEntity.mr_deleteAll(matching: predicate, in: context)
    }

    func fill(from file: GistFile, overwriteContent: Bool) {
        filename = file.filename!

        type = file.type
        language = file.language
        rawUrl = file.rawUrl
        size = NSNumber(value: file.size)

        if overwriteContent || file.content != nil {
            content = file.content
        }
    }

    // MARK: Private

    private static func fingMaxOrder(withFilename filename: String, gist: GistEntity,
                                     in context: NSManagedObjectContext?) -> Int {
        let predicate = GistFileEntity.predicate(with: filename, gist: gist)
        let fileEntity = GistFileEntity.mr_findFirst(with: predicate,
                                                     sortedBy: "order",
                                                     ascending: false,
                                                     in: context) as? GistFileEntity
        return fileEntity?.order?.intValue ?? 0
    }

}
