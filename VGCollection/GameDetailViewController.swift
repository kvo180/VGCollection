//
//  GameDetailViewController.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/20/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var gameDetailScrollView: UIScrollView!
    @IBOutlet weak var gameCoverImageView: UIImageView!
    var game: Game!
    
    
    // MARK: - UI Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        
        gameCoverImageView.alpha = 0
        gameCoverImageView.contentMode = .scaleAspectFit
        
        // Configure navigation controller

//        navigationController!.navigationBar.translucent = true
//        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        navigationController!.navigationBar.shadowImage = UIImage()
//        navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
//        navigationController!.view.backgroundColor = UIColor.clearColor()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IGDBClient.sharedInstance().dataTaskForImageWithSize(IGDBClient.Images.CoverBig, imageID: game.imageID!) { (downloadedImage, error) in
            
            if let coverImage = downloadedImage {
                DispatchQueue.main.async {
                    self.gameCoverImageView.image = coverImage
                    self.gameCoverImageView.fadeIn()
                }
            }
            else {
                // what to do if game doesn't have a cover photo??
            }
        }
    }
    
}
