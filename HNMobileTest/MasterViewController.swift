//
//  MasterViewController.swift
//  HNMobileTest
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var hits: [Hit] = []
    var noHits: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Deslizar para obtener noticias")
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.loadNews), for: UIControl.Event.valueChanged)
        loadNews()
    }

    @objc private func loadNews() {
        self.refreshControl!.endRefreshing()
        RestClient.sharedInstance.hits(completion: { (news) in
            UserDefaultsUtils.saveHits(news!.hits)
            self.reloadHits()
        }) { (error) in
            iToast.makeText("Error inesperado").setDuration(3000).setGravity(iToastGravityBottom).show(iToastTypeWarning)
        }
    }

    private func reloadHits() {
        hits = UserDefaultsUtils.loadHits()
        noHits = hits.isEmpty

        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)

        reloadHits()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb" {

            let hit = sender as! Hit
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.hit = hit
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true

        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.section), \(indexPath.row)")

        if noHits {
            return
        }

        let hit = hits[indexPath.row]
        if hit.storyUrl != nil {
            self.performSegue(withIdentifier: "showWeb", sender: hit)
        } else {
            iToast.makeText("Articulo sin enlace").setDuration(3000).setGravity(iToastGravityBottom).show(iToastTypeWarning)
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noHits {
            return 0
        }
        return hits.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell:HitTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? HitTableViewCell

        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("HitTableViewCell", owner: self, options: nil)!
            cell = nib[0] as? HitTableViewCell
        }

        let hit = hits[indexPath.row]
        let defaultTitle = "Untitle";
        var authorWithDate = "Anonymous";

        if let title = hit.title {
            cell!.titleLabel.text = title;
        } else if let title = hit.storyTitle{
            cell!.titleLabel.text = title
        } else {
            cell!.titleLabel.text = defaultTitle;
        }

        if let author = hit.author {
            authorWithDate = author
        }

        if let createdAtI = hit.createdAtI {
            let createDate = Date(timeIntervalSince1970: TimeInterval(createdAtI))
            authorWithDate += " - \(formatElapsedTime(creationDate: createDate))"
        }

        cell!.authorLabel.text = authorWithDate

        return cell
    }

    private func formatElapsedTime(creationDate: Date) -> String {
        let now = Date()
        let seconds: Int = Int(now.timeIntervalSince(creationDate))
        var elapsedTime = ""
        switch seconds {
        case 0...59:
            elapsedTime = String((seconds % 3600) % 60) + "s"
            break
        case 60...3599:
            elapsedTime = String((seconds % 3600) / 60) + "m"
            break
        case 3600...86399:
            elapsedTime = String((seconds % 86400) / 3600) + "h"
            break
        case 86400...604800:
            elapsedTime = String((seconds / 86400)) + "d"
            break
        default:
            elapsedTime = "*"
        }

        return elapsedTime
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserDefaultsUtils.deleteHit(self.hits[indexPath.row])
            self.hits.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.reloadHits()
            iToast.makeText("Eliminación exitosa").setDuration(3000).setGravity(iToastGravityBottom).show(iToastTypeWarning)
        }
    }

}

