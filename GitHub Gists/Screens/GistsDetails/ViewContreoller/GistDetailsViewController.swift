//
//  GistsDetailsViewController.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import CoreData

class GistDetailsViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    GistDetailsModelObserver,
    NSFetchedResultsControllerDelegate {

    var router: Rourer!
    var reloadContentAfterAppeare: Bool = false
    var model: GistDetailsModel! {
        willSet {
            if model != nil {
                model.observer = nil
            }
            if frc != nil {
                frc.delegate = nil
                frc = nil
            }
        }
        didSet {
            model.observer = self
            frc = model?.obtainFilesFRC()
            frc.delegate = self
        }
    }

    private var frc: NSFetchedResultsController<GistFileEntity>!

    // MARK: UIViewControlle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if reloadContentAfterAppeare {
            model.reloadGist()
        }
    }

    // MARK: UI

    @IBOutlet weak var tableView: UITableView!
    private let infoCellIdentifier = "InfoCell"
    private let fileCellIdentifier = "FileCell"

    private func configureUI() {

        tableView.register(UINib.init(nibName: "GistInfoTableViewCell", bundle: nil),
                           forCellReuseIdentifier: infoCellIdentifier)
        tableView.register(UINib.init(nibName: "GistFileTableViewCell", bundle: nil),
                           forCellReuseIdentifier: fileCellIdentifier)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self,
                                            action: #selector(handleRefresh(_:)),
                                            for: UIControlEvents.valueChanged)

        tableView.tableFooterView = LoadMoreIndicator()
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        model?.reloadGist()
    }

    // MARK: GistDetailsModelObserver

    func finishLoading(successful: Bool, withError error: GistsError?) {
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: UITableViewDataSource

    private enum Sections: Int {
        case info = 0
        case files = 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if (frc?.sections?.first?.numberOfObjects ?? 0) > 0 {
            numberOfSections += 1
        }
        return  numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.info.rawValue:
            return 1
        case Sections.files.rawValue:
            return frc?.sections?.first?.numberOfObjects ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.info.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath)
                                                        as? GistInfoTableViewCell {
                if let gist = model.obtainGistEntity() {
                    cell.configure(with: gist)
                }
                return cell
            }
        case Sections.files.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: fileCellIdentifier, for: indexPath)
                                                       as? GistFileTableViewCell {
                let fileIndexPath = IndexPath(item: indexPath.item, section: 0)
                if let file = frc?.object(at: fileIndexPath) {
                    cell.configure(file: file)
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Sections.files.rawValue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == Sections.files.rawValue else {
            return
        }

        let fileIndexPath = IndexPath(item: indexPath.item, section: 0)
        if let file = frc?.object(at: fileIndexPath) {
            router!.showFileContent(withUserName: model.username, gistId: model.gistId, filename: file.filename)
        }
    }

    // MARK: NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        var fileIndexPath: IndexPath?
        if indexPath != nil {
            fileIndexPath = IndexPath(item: indexPath!.item, section: Sections.files.rawValue)
        }

        var newFileIndexPath: IndexPath?
        if newIndexPath != nil {
            newFileIndexPath = IndexPath(item: newIndexPath!.item, section: Sections.files.rawValue)
        }

        switch type {
        case .insert:
            if let newFileIndexPath = newFileIndexPath {
                tableView.insertRows(at: [newFileIndexPath], with: .automatic)
            }
        case .delete:
            tableView.deleteRows(at: [fileIndexPath!], with: .automatic)
        case .move:
            if indexPath != newIndexPath,
                let fileIndexPath = fileIndexPath,
                let newFileIndexPath = newFileIndexPath {
                tableView.moveRow(at: fileIndexPath, to: newFileIndexPath)
            } else {
                tableView.reloadRows(at: [fileIndexPath!], with: .automatic)
            }
        case .update:
            tableView.reloadRows(at: [fileIndexPath!], with: .automatic)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
