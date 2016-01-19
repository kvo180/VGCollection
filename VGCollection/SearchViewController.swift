//
//  SearchViewController.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/14/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    let darkGrayColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var games = [Game]()
    
    // Reference to most recent data download task
    var searchTask: NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        resultsTableView.separatorColor = UIColor.whiteColor()
        resultsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - UISearchBar Delegate Methods
    
    // Update search result as user types searchText
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
            print("Task canceled")
        }
        
        // If textfield is empty, exit method
        if searchText == "" {
            games = [Game]()
            resultsTableView.reloadData()
            print("Method exited")
            return
        }
        
        // Start new dataTask
        let parameters = ["q" : searchText]
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
                    
                    // Reload tableView on main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        self.resultsTableView.reloadData()
                    }
                } else {
                    print("Cannot find key \(IGDBClient.JSONResponseKeys.Games) in \(result)")
                }
            }
        }
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID)!
        cell.textLabel!.text = game.name
        cell.detailTextLabel?.text = game.releaseYear
        print(game.releaseYear)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
    }
    
    
    // MARK: - Utilities
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
