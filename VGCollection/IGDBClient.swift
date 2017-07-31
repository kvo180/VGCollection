//
//  IGDBClient.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/15/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class IGDBClient: NSObject {
    
    // MARK: - Properties
    var session: URLSession!
    
    
    // MARK: - Initializers
    override init() {
        super.init()
        session = URLSession.shared
    }
    
    
    // MARK: - dataTaskWithRequest
    
    func dataTaskForResource(_ request: NSMutableURLRequest, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 4. Make the request */
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    
                    let localizedResponse = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    print("Your request returned an invalid response! Status code: \(response.statusCode). Description: \(localizedResponse).")
                    
                    let userInfo = [NSLocalizedDescriptionKey : "\(response.statusCode) - \(localizedResponse)"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                    
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    let userInfo = [NSLocalizedDescriptionKey : "The request returned an invalid response code"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                    
                } else {
                    print("Your request returned an invalid response!")
                    let userInfo = [NSLocalizedDescriptionKey : "The request returned an invalid response code"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                }
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                let userInfo = [NSLocalizedDescriptionKey : "Unable to retrieve data from server"]
                completionHandler(result: nil, error: NSError(domain: "data", code: 3, userInfo: userInfo))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            IGDBClient.parseJSONDataWithCompletionHandler(data, completionHandler: completionHandler)
        }) 
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: - Data task for getting images
    
    func dataTaskForImageWithSize(_ size: String, imageID: String, completionHandler: @escaping (_ downloadedImage: UIImage?, _ error: NSError?) -> Void) {
        
        let urlString = Constants.baseImageURLSecure + size + "/" + "\(imageID).jpg"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(downloadedImage: nil, error: error)
            } else {
                if let image = UIImage(data: data!) {
                    completionHandler(downloadedImage: image, error: nil)
                }
                else {
                    print("image does not exist at URL")
                    completionHandler(downloadedImage: nil, error: nil)
                }
            }
        }) 
        task.resume()
    }
    
    
    // MARK: - Configure URL Request
    
    func configureURLRequestForResource(_ resource: String, parameters: [String : AnyObject]) -> NSMutableURLRequest {
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + resource + IGDBClient.escapedParameters(parameters)
        print(urlString)
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Token token=\(Constants.APIKey)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
    // MARK: - Helpers
    
    class func parseJSONDataWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(parsedResult, nil)
    }
    
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    
    // MARK: - Shared Instance
    class func sharedInstance() -> IGDBClient {
        
        struct Singleton {
            static var sharedInstance = IGDBClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
    // MARK: - Shared Image Cache
    
    struct Caches {
        static let imageCache = ImageCache()
    }
}
