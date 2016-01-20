//
//  GameDetailViewController.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/20/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var gameDetailScrollView: UIScrollView!
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    var game: Game!
    
    
    // MARK: - UI Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameCoverImageView.alpha = 0
        gameCoverImageView.contentMode = .ScaleAspectFit
        
        navigationController!.navigationBarHidden = true
        navigationController!.interactivePopGestureRecognizer?.delegate = self
        tabBarController!.tabBar.hidden = true
        
        // MARK: Custom Back Button
        let backImage = UIImage(named: "back")
        let systemColorBackImage = backImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        backButton.setImage(systemColorBackImage, forState: .Normal)
        backButton.tintColor = view.tintColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IGDBClient.sharedInstance().dataTaskForImageWithSize(IGDBClient.Images.CoverBig, imageID: game.imageID!) { (downloadedImage, error) in
            
            if let coverImage = downloadedImage {
                dispatch_async(dispatch_get_main_queue()) {
                    self.gameCoverImageView.image = coverImage
                    self.gameCoverImageView.fadeIn()
                }
            }
            else {
                // what to do if game doesn't have a cover photo??
            }
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func backButtonTouchUp(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
