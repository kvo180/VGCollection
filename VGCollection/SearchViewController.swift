//
//  SearchViewController.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/14/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    let darkGrayColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var games = [Game]()
    
    // Reference to most recent data download task
    var searchTask: NSURLSessionDataTask?
    
    
    // MARK: - UI Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noResultsLabel.hidden = true
        searchBar.delegate = self
        
        // MARK: Configure search bar
        
        // Cancel button color
        let cancelButtonAttributes: NSDictionary = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName: self.view.tintColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
        // Search bar text color
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        // Search bar keyboard color
        searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        
        // MARK: Configure table view
        
        resultsTableView.backgroundColor = UIColor.blackColor()
        resultsTableView.tableFooterView = UIView(frame: CGRectZero)
        resultsTableView.rowHeight = 75.0
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        navigationController!.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
    }
    
    
    // MARK: - UISearchBar Delegate Methods
    
    // Update search result as user types searchText
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If textfield is empty, exit method
        if searchText == "" {
            games = [Game]()
            resultsTableView.reloadData()
            noResultsLabel.hidden = true
            return
        }
        
        // // Start new dataTask if searchText contains 2 or more characters
        if searchText.characters.count >= 2 {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            noResultsLabel.hidden = true
            
            let parameters: [String : AnyObject] = [
                "q" : searchText.lowercaseString,
                "limit" : 50
            ]
            
            let request = IGDBClient.sharedInstance().configureURLRequestForResource(IGDBClient.Resources.GamesSearch, parameters: parameters)
            
            searchTask = IGDBClient.sharedInstance().dataTaskForResource(request) { (result, error) in
                
                if let error = error {
                    print("Error searching for games: \(error.localizedDescription)")
                    return
                } else {
                    if let gameDictionaries = result.valueForKey(IGDBClient.JSONResponseKeys.Games) as? [[String : AnyObject]] {
                        self.searchTask = nil
                        
                        // Create an array of Game instances to display in resultsTableView
                        self.games = gameDictionaries.map() {Game(dictionary: $0)}
                        print(self.games.count)
                        
                        // Reload tableView on main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.resultsTableView.reloadData()
                            
                            if self.games.isEmpty {
                                self.noResultsLabel.hidden = false
                            } else {
                                self.noResultsLabel.hidden = true
                            }
                        }
                    } else {
                        print("Cannot find key \(IGDBClient.JSONResponseKeys.Games) in \(result)")
                    }
                }
            }
        } else {
            noResultsLabel.hidden = false
        }
        
//        let parameters = ["name" : searchText]
//        let request = TheGamesDBClient.sharedInstance().configureURLRequestForResource(TheGamesDBClient.Resources.GetGamesList, parameters: parameters)
//        
//        searchTask = TheGamesDBClient.sharedInstance().dataTaskForResource(request) { (result, error) in
//            
//            if let error = error {
//                print("Error searching for games: \(error.localizedDescription)")
//                return
//            } else {
//                if let gameDictionaries = result.valueForKey(IGDBClient.JSONResponseKeys.Games) as? [[String : AnyObject]] {
//                    self.searchTask = nil
//                    
//                    print(result)
//                    
//                    // Create an array of Game instances to display in resultsTableView
//                    self.games = gameDictionaries.map() {Game(dictionary: $0)}
//                    
//                    // Reload tableView on main thread
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.resultsTableView.reloadData()
//                    }
//                } else {
//                    print("Cannot find key \(IGDBClient.JSONResponseKeys.Games) in \(result)")
//                }
//            }
//        }

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseID = "SearchTableViewCell"
        let game = games[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID) as! SearchResultsTableViewCell
        cell.coverImageView.image = UIImage(named: "blackbox")
        cell.coverImageView.alpha = 0
        
        cell.nameLabel.text = game.name
        cell.nameLabel.font = UIFont.boldSystemFontOfSize(17)
        cell.nameLabel.textColor = UIColor.whiteColor()
        cell.yearLabel.text = game.releaseYear
        cell.yearLabel.font = UIFont.systemFontOfSize(13)
        cell.yearLabel.textColor = UIColor.whiteColor()

        // Get cover photo
        if let storedCoverImage = game.image {
            cell.coverImageView.image = storedCoverImage
            cell.coverImageView.alpha = 1
        }
        else {
            if let imageID = game.imageID {
                IGDBClient.sharedInstance().dataTaskForImageWithSize(IGDBClient.Images.CoverSmall, imageID: imageID) { (downloadedImage, error) in
                    
                    if let image = downloadedImage {
                        game.image = image
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.coverImageView.image = game.image
                            cell.coverImageView.fadeIn()
                        }
                    }
                }
            } else {
                cell.coverImageView.image = UIImage(named: "camera")
                cell.coverImageView.alpha = 1
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowGameDetail", sender: indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let gameDetailVC = segue.destinationViewController as! GameDetailViewController
        gameDetailVC.game = games[(sender as! NSIndexPath).row]
    }
    
    
    // MARK: - Utilities
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
