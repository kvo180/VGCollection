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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        // TODO: call API request
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // TODO: Segue to game detail
        print("TODO: Segue to game detail")
        
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseID = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID)!
        cell.textLabel?.text = "test"
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()

    }
    
    
    // MARK: - Utilities
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
