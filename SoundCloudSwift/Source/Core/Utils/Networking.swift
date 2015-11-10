import Foundation
import Alamofire


/**
 Executes a POST request
 
 - parameter url:        url
 - parameter parameters: parameters
 - parameter completion: completionc losure
 */
func jsonPOSTRequest(url: NSURL, parameters: [String: AnyObject], completion: ([String: AnyObject], NSError?) -> Void) {
    
    let (request, error) = Alamofire.ParameterEncoding.JSON.encode(NSURLRequest(URL: url), parameters: parameters)
    if let error = error {
        completion([:], error)
        return
    }
    request.HTTPMethod = "POST"
    request.allHTTPHeaderFields = ["Content-Type": "application/json"]
    let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    session.dataTaskWithRequest(request) { (data, response, error) -> Void in
        if let error = error {
            completion([:], error)
        }
        else if let data = data {
            let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
            if let dict = dict {
                completion(dict!, nil)
            }
            else {
                completion([:], nil)
            }
        }
        else {
            completion([:], nil)
        }
    }.resume()
}