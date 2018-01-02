//
//  File.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var timerLabel: UIButton!
    var photos: [FlickrPhoto] = []
    var sec:Double?
    
    override func viewDidLoad() {
        self.getImage()
        self.showRandom()
        timerLabel.setTitle("Timer : \(String(Int(sec!))) sec", for: .normal)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gImage(_ sender: Any) {
    }
  
    func showRandom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + sec!) { // 2
            self.getImage()
            self.showRandom()
        }
    }
    
    func getImage() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.photos.count)))
        self.photoImageView.downloadedFrom(url: self.photos[randomIndex].photoUrl as URL)
    }
}
