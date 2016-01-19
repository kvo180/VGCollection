//
//  IGDBClient.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/15/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import Foundation

class IGDBClient: NSObject {
    
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Token token=\(Constants.APIKey)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
    // MARK: - Helpers
    
    class func parseJSONDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    // MARK: - Shared Instance
    class func sharedInstance() -> IGDBClient {
        
        struct Singleton {
            static var sharedInstance = IGDBClient()
        }
        
        return Singleton.sharedInstance
    }
}