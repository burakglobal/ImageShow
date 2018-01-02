//
//  File.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
}
