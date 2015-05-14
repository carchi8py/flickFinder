//
//  ViewController.swift
//  flickFinder
//
//  Created by Chris Archibald on 5/13/15.
//  Copyright (c) 2015 Chris Archibald. All rights reserved.
//

import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "82f838e6ec0855fcfc15838a9f8ed333"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var pharseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    @IBAction func searchPhotosByPhrase(sender: AnyObject) {
        /* 1 Hardcore the arguments */
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": "baby asian elephant",
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        /* 2 - Call the Flickr API with these arguments */
        getImageFromFlickrBySearch(methodArguments)
    }
    
    @IBAction func searchPhotosByLatLong(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        
        /* 3 - Get the shared NSURLSession to faciliate network activity */
        let session = NSURLSession.sharedSession()
        
        /* 4 - Create the NSURLRequest using properly escaped URL */
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 5 - Create NSURLSessionDataTask and completion handler */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let photosDiectionary = parsedResult.valueForKey("photos") as? NSDictionary {
                    if let photoArray = photosDiectionary.valueForKey("photo") as? [[String: AnyObject]] {
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
                        
                        /* Prepare the Ui updates */
                        let photoTitle = photoDictionary["title"] as? String
                        let imageUrlString = photoDictionary["url_m"] as? String
                        let imageUrl = NSURL(string: imageUrlString!)
                        
                        if let imageData = NSData(contentsOfURL: imageUrl!) {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.photoTitleLabel.text = photoTitle
                                self.photoImageView.image = UIImage(data: imageData)
                            })
                        }
                        
                    } else {
                        self.photoTitleLabel.text = ("Can't find key photo in \(photosDiectionary)")
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.photoTitleLabel.text = "No Photos found"
                        self.photoImageView.image = nil
                    })
                }
            }
        }
        
        /* 6 - Resume (execute) the task */
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
}

