//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {

    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    var repos = [GithubRepo]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        
        
        // tableView
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // Perform the search.
    private func doSearch() {

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            for repo in newRepos {
                self.repos.append(repo)
            }   
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepoCell
        
        let repo = repos[indexPath.row]
        
        if let name = repo.name {
            cell.nameLabel.text = name
        }

        if let repoDescription = repo.repoDescription {
            cell.descriptionLabel.text = repoDescription
        }
        
        if let ownerHandle = repo.ownerHandle {
            cell.ownerLabel.text = ownerHandle
        }
        
        if let stars = repo.stars {
            cell.starLabel.text = String(stars)
        }
        
        if let forks = repo.forks {
            cell.forkLabel.text = String(forks)
        }
        
        if let ownerAvatarUrl = repo.ownerAvatarURL {
            let url = NSURL(string: ownerAvatarUrl)
            cell.avatarImage.setImageWithURL(url!)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as!UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        if let minStars = filters["minStars"] as? Float {
            print(minStars)
            let settings = GithubRepoSearchSettings.init()
            settings.minStars = Int(minStars)
            GithubRepo.fetchRepos(settings, successCallback: { (newRepos) -> Void in
                
                // Print the returned repositories to the output window
                self.repos = [GithubRepo]()
                for repo in newRepos {
                    if repo.stars >= settings.minStars {
                        self.repos.append(repo)
                    }
                }
                
                self.tableView.reloadData()
                print("getting here")
                }, error: { (error) -> Void in
                    print(error)
            })
            
        }
    }
}


// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
    
}