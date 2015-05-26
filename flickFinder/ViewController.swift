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
    
    // The variables we need to pass to flicers API
    @IBAction func searchPhotosByPhrase(sender: AnyObject) {
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": "baby asian elephant",
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        getImageFromFlickrBySearch(methodArguments)
    }
    
    //TODO: this function needs to be complete
    @IBAction func searchPhotosByLatLong(sender: AnyObject) {
        println("Will implement this function in a later step...")
    }
    
    //TODO: implement the tapRecognizer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Initialize the tapRecognizer in viewDidLoad")
    }
    
    //TODO: Add TapRecongizer
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("Add the tapRecognizer and subscribe to keyboard notifications in viewWillAppear")
    }
    
    //TODO: Remove TapRecongizer
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        println("Remove the tapRecognizer and unsubscribe from keyboard notifications in viewWillDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* ============================================================
    * Functional stubs for handling UI problems
    * ============================================================ */
    
    /* 1 - Dismissing the keyboard */
    func addKeyboardDismissRecognizer() {
        println("Add the recognizer to dismiss the keyboard")
    }
    
    func removeKeyboardDismissRecognizer() {
        println("Remove the recognizer to dismiss the keyboard")
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        println("End editing here")
    }
    
    /* 2 - Shifting the keyboard so it does not hide controls */
    func subscribeToKeyboardNotifications() {
        println("Subscribe to the KeyboardWillShow and KeyboardWillHide notifications")
    }
    
    func unsubscribeToKeyboardNotifications() {
        println("Unsubscribe to the KeyboardWillShow and KeyboardWillHide notifications")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        println("Shift the view's frame up so that controls are shown")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("Shift the view's frame down so that the view is back to its original placement")
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        println("Get and return the keyboard's height from the notification")
        return 0.0
    }

/* ============================================================ *


    // Call the flicker API and returns a random image based on what we are searching for
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        
        let session = NSURLSession.sharedSession()
        
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
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

