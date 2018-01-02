//
//  File.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    func setupWithPhoto(flickrPhoto: FlickrPhoto) {
        resultTitleLabel.text = flickrPhoto.title
        
        if flickrPhoto.photoUrl.absoluteString != nil {
            resultImageView.downloadedFrom(url: flickrPhoto.photoUrl as URL)
        }
        
    }
    
}
