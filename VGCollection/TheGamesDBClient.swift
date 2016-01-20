//
//  TheGamesDBClient.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/18/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class TheGamesDBClient: NSObject, NSXMLParserDelegate {
 
    // MARK: - Properties
    var session: NSURLSession!
    
    
    // MARK: - Initializers
    override init() {
        super.init()
        session = NSURLSession.sharedSession()
    }
    
    
    // MARK: - dataTaskWithRequest
    
    func dataTaskForResource(request: NSMutableURLRequest, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    
                    let localizedResponse = NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
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
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: - Configure URL Request
    
    func configureURLRequestForResource(resource: String, parameters: [String : AnyObject]) -> NSMutableURLRequest {
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + resource + IGDBClient.escapedParameters(parameters)
        print(urlString)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        return request
    }
    
    
    // MARK: - Helpers
    
//    class func parseXMLDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
//        let parser = NSXMLParser(data: data)
//        parser.delegate = self
//        var parsedResult: AnyObject!
//        do {
//            parsedResult = try NSXMLParser.
//        }
//    }
    
    
    // MARK: - Shared Instance
    class func sharedInstance() -> TheGamesDBClient {
        
        struct Singleton {
            static var sharedInstance = TheGamesDBClient()
        }
        
        return Singleton.sharedInstance
    }
}
