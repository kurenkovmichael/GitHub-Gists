//
//  GistsListViewController.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import CoreData

class GistsListViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    GistsListModelObserver,
    NSFetchedResultsControllerDelegate {

    var router: Rourer!
    var reloadContentAfterAppeare: Bool = false
    var model: GistsListModel! {
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
            frc = model?.obtainFRC()
            frc.delegate = self
        }
    }

    private var frc: NSFetchedResultsController<GistEntity>!

    // MARK: UIViewControlle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = model?.username
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        tableView.reloadData()

        placeholder.error = nil
        if reloadContentAfterAppeare || isEmpty {
            reloadContentAfterAppeare = false
            model.reloadGistsList()
        }

        if model.canCreateGist && navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem
                = UIBarButtonItem(barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector(createGist(_:)))
        } else if !model.canCreateGist && navigationItem.rightBarButtonItem != nil {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @objc func createGist(_ item: UIBarButtonItem) {
        router.showCreateGist()
    }

    // MARK: UI

    @IBOutlet weak var tableView: UITableView!
    private let gistCellIdentifier = "GistCell"

    weak var placeholder: Placeholder!

    func configureUI() {
        tableView.register(UINib.init(nibName: "GistTableViewCell", bundle: nil),
                           forCellReuseIdentifier: gistCellIdentifier)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)

        tableView.tableFooterView = LoadMoreIndicator()

        placeholder = Placeholder.fromNib()
        placeholder.add(on: view, animated: false)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        reloadGistsList()
    }

    var loadMoreIndicator: LoadMoreIndicator? {
        return tableView.tableFooterView as? LoadMoreIndicator
    }

    // MARK: Private

    private var isEmpty: Bool {
        return (frc.sections?.first?.numberOfObjects ?? 0) == 0
    }

    private var availableLoadingMore: Bool {
        return !isEmpty &&
               !(tableView.refreshControl?.isRefreshing ?? false) &&
               !model.isLoading
    }

    private func reloadGistsList() {
        placeholder.hide()
        placeholder.error = nil

        loadMoreIndicator?.stopAnimating()
        model.reloadGistsList()
    }

    private func loadMoreIfPosible() {
        guard availableLoadingMore else {
            return
        }

        placeholder.hide()
        placeholder.error = nil

        loadMoreIndicator?.startAnimating()
        model.loadNextPage()
    }

    // MARK: GistsListModelObserver

    func finishLoading(successful: Bool, withError error: GistsError?) {
        tableView.refreshControl?.endRefreshing()
        loadMoreIndicator?.stopAnimating()

        if isEmpty {
            placeholder.error = error ?? .noGists
            placeholder.show()
        } else {
            placeholder.hide()
        }
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.sections?.first?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: gistCellIdentifier, for: indexPath)
                                                    as? GistTableViewCell {
            if let gists = frc?.object(at: indexPath) {
                cell.configure(with: gists)
            }
            return cell
        }

        return UITableViewCell()
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let gist = frc?.object(at: indexPath) {
            router!.showGistsGistsDetails(withUserName: gist.username, gistId: gist.id)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = -scrollView.contentInset.top - scrollView.contentOffset.y
        let opacity = max(min(1 - offset / 50, 1), 0)
        placeholder.show(opacity: Float(opacity))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let distanceToReload = CGFloat(LoadMoreIndicator.defaultSize / 2)
        if maximumOffset - currentOffset < distanceToReload {
            loadMoreIfPosible()
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
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            if indexPath != newIndexPath {
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            } else {
                tableView.reloadRows(at: [indexPath!], with: .automatic)
            }
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
