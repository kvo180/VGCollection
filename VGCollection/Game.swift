//
//  Game.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/16/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    struct Keys {
        static let Name = "name"
        static let ID = "id"
        static let ReleaseDate = "release_date"
        static let Cover = "cover"
        static let CoverID = "cover_id"
    }
    
    var name = ""
    var id: Int!
    var releaseDate: String? = nil
    var releaseYear: String? = nil
    var imageID: String? = nil
    var imagePath: String? = nil
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary[Keys.Name] as! String
        id = dictionary[Keys.ID] as! Int
        
        if let releaseDate = dictionary[Keys.ReleaseDate] as? String {
            self.releaseDate = releaseDate
            releaseYear = (releaseDate as NSString).substring(to: 4)
        } else {
            releaseDate = ""
            releaseYear = ""
        }
        
        if let coverID = dictionary[Keys.CoverID] as? String {
            imageID = coverID
            imagePath = "\(coverID).jpg"
        }
    }
    
    var image: UIImage? {
        
        get {
            return IGDBClient.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        set {
            IGDBClient.Caches.imageCache.storeImage(newValue, withIdentifier: imagePath!)
        }
    }
}
