//
//  MagicalRecord+Gists.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import MagicalRecord

extension MagicalRecord {

    static func saveGists(_ gistsToSave: [Gist],
                          username: String,
                          append: Bool,
                          completion: @escaping (Bool, Error?) -> Void) {
        MagicalRecord.save({ (context) in
            if !append {
                GistEntity.delete(with: username,
                                  exclusionGistsWithIds: gistsToSave.compactMap { $0.gistId },
                                  in: context)
            }

            for gist in gistsToSave {
                guard let gistEntity = GistEntity.findOrCreate(with: username, gistId: gist.gistId, in: context) else {
                    continue
                }

                gistEntity.fill(from: gist)

                let files = gist.files.values
                GistFileEntity.delete(from: gistEntity,
                                      exclusionFilesWithNames: files.compactMap { $0.filename },
                                      in: context)
                for file in files {
                    guard let filename = file.filename else {
                        continue
                    }
                    let fileEntity = GistFileEntity.findOrCreate(with: filename,
                                                                 gist: gistEntity,
                                                                 in: context)
                    fileEntity.fill(from: file, overwriteContent: false)
                }
            }
        }, completion: completion)
    }

    static func saveGist(_ gistToSave: Gist,
                         username: String,
                         completion: @escaping (Bool, Error?) -> Void) {
        MagicalRecord.save({ (context) in
            guard let gistEntity = GistEntity.find(with: username, gistId: gistToSave.gistId, in: context) else {
                    return
            }

            gistEntity.fill(from: gistToSave)

            let files = gistToSave.files.values
            GistFileEntity.delete(from: gistEntity,
                                  exclusionFilesWithNames: files.compactMap { $0.filename },
                                  in: context)
            for file in files {
                guard let filename = file.filename else {
                    continue
                }
                let fileEntity = GistFileEntity.findOrCreate(with: filename,
                                                             gist: gistEntity,
                                                             in: context)
                fileEntity.fill(from: file, overwriteContent: true)
            }
        }, completion: completion)
    }

}
