//
//  File.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class ImageCache {
    
    fileprivate var inMemoryCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: - Retrieving images
    
    func imageWithIdentifier(_ identifier: String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            print("no identifier")
            return nil
        }
        
        else {
            let path = pathForIdentifier(identifier!)
            
            // First try the memory cache
            if let image = inMemoryCache.object(forKey: path as AnyObject) as? UIImage {
                print("image retrieved from memory cache")
                return image
            }
                // Next Try the hard drive
            else if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                print("image retrieved from hard drive")
                return UIImage(data: data)
            }
            else {
                print("could not retrieve image")
                return nil
            }
        }
    }
    
    // MARK: - Saving images
    
    func storeImage(_ image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            print("image is nil")
            inMemoryCache.removeObject(forKey: path as AnyObject)
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch _ {
            }
            return
        }
        else {
            // Otherwise, keep the image in memory
            inMemoryCache.setObject(image!, forKey: path as AnyObject)
            
            // And in documents directory
            let data = UIImageJPEGRepresentation(image!, 1.0)
            try? data!.write(to: URL(fileURLWithPath: path), options: [.atomic])
            
            print("image stored at path: \(path)")
        }
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(_ identifier: String) -> String {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURL = documentsDirectoryURL.appendingPathComponent(identifier)
        
        return fullURL.path
    }
}
