//
//  File.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import Foundation

class FlickrProvider {
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
    struct Keys {
        static let flickrKey = "11974201e260f40e92d8512a0f6ff6ea"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(searchText: String, onCompletion: @escaping FlickrResponse) -> Void {
        let escapedSearchText: String = searchText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.flickrKey)&tags=\(escapedSearchText)&per_page=200&format=json&nojsoncallback=1&safe_search=3"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error ?? "Error" as! Error)")
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results["code"] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidAccessError, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                print(photosArray)
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        })
        searchTask.resume()
    }
    
}
