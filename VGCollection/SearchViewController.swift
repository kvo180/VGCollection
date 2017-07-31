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
    

    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    let darkGrayColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var games = [Game]()
    
    // Reference to most recent data download task
    var searchTask: URLSessionDataTask?
    
    
    // MARK: - UI Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noResultsLabel.isHidden = true
        searchBar.delegate = self
        self.edgesForExtendedLayout = UIRectEdge.all
        
        // MARK: Configure search bar
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Test"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = leftNavBarButton
        
        // Cancel button color
        let cancelButtonAttributes: NSDictionary = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0), NSForegroundColorAttributeName: self.view.tintColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState())
        
        // Search bar text color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        // Search bar keyboard color
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
        // MARK: Configure table view
        
        resultsTableView.backgroundColor = UIColor.black
        resultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        resultsTableView.rowHeight = 75.0
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        
//        navigationController?.navigationBarHidden = true
//        tabBarController!.tabBar.hidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController!.navigationBar.isTranslucent = true
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.backgroundColor = UIColor.clear
        navigationController!.view.backgroundColor = UIColor.clear
        
//        navigationController?.navigationBarHidden = false
//        tabBarController!.tabBar.hidden = true
    }
    
    
    // MARK: - UISearchBar Delegate Methods
    
    // Update search result as user types searchText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If textfield is empty, exit method
        if searchText == "" {
            games = [Game]()
            resultsTableView.reloadData()
            noResultsLabel.isHidden = true
            return
        }
        
        // // Start new dataTask if searchText contains 2 or more characters
        if searchText.characters.count >= 2 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            noResultsLabel.isHidden = true
            
            let parameters: [String : AnyObject] = [
                "q" : searchText.lowercased() as AnyObject,
                "limit" : 50 as AnyObject
            ]
            
            let request = IGDBClient.sharedInstance().configureURLRequestForResource(IGDBClient.Resources.GamesSearch, parameters: parameters)
            
            searchTask = IGDBClient.sharedInstance().dataTaskForResource(request as URLRequest) { (result, error) in
                
                if let error = error {
                    print("Error searching for games: \(error.localizedDescription)")
                    return
                } else {
                    if let gameDictionaries = result?.value(forKey: IGDBClient.JSONResponseKeys.Games) as? [[String : AnyObject]] {
                        self.searchTask = nil
                        
                        // Create an array of Game instances to display in resultsTableView
                        self.games = gameDictionaries.map() {Game(dictionary: $0)}
                        print(self.games.count)
                        
                        // Reload tableView on main thread
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.resultsTableView.reloadData()
                            
                            if self.games.isEmpty {
                                self.noResultsLabel.isHidden = false
                            } else {
                                self.noResultsLabel.isHidden = true
                            }
                        }
                    } else {
                        print("Cannot find key \(IGDBClient.JSONResponseKeys.Games) in \(String(describing: result))")
                    }
                }
            }
        } else {
            noResultsLabel.isHidden = false
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "SearchTableViewCell"
        let game = games[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! SearchResultsTableViewCell
        cell.coverImageView.image = UIImage(named: "blackbox")
        cell.coverImageView.alpha = 0
        
        cell.nameLabel.text = game.name
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.nameLabel.textColor = UIColor.white
        cell.yearLabel.text = game.releaseYear
        cell.yearLabel.font = UIFont.systemFont(ofSize: 13)
        cell.yearLabel.textColor = UIColor.white

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
                        
                        DispatchQueue.main.async {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowGameDetail", sender: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let gameDetailVC = segue.destination as! GameDetailViewController
        gameDetailVC.game = games[(sender as! IndexPath).row]
    }
    
    
    // MARK: - Utilities
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
