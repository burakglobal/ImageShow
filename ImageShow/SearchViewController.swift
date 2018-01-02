//
//  File.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
  
    @IBOutlet weak var timerSlider: UISlider! 
    @IBOutlet weak var timerLabel: UILabel!
    var photos: [FlickrPhoto] = []
    var searchArray = ["funny dogs", "funny cats"]
    var timerSecs = 0.0
    
    // MARK: - Actions
    @IBAction func startShowTapped(_ sender: Any) {
        let randomIndex = Int(arc4random_uniform(UInt32(searchArray.count)))
        print(searchArray[randomIndex])
        performSearchWithText(searchText: searchArray[randomIndex])
    }

    @IBAction func sliderChanged(_ sender: Any) {
        timerLabel.text = "Set Timer: \(Int(timerSlider.value)) sec"
    }
    
    // MARK: - Private
    private func performSearchWithText(searchText: String) {
         FlickrProvider.fetchPhotosForSearchText(searchText: searchText, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
             if error == nil {
                self.photos = flickrPhotos!
                DispatchQueue.main.async(execute: { () -> Void in
                    self.timerSecs = Double(self.timerSlider.value)
                })
                
                let toViewController = initFromStoryboard(name: "Main", identifier: PhotoViewController.identifier) as! PhotoViewController
                toViewController.photos = self.photos
                toViewController.sec = Double(self.timerSecs)
                self.present(toViewController, animated: false)
                
                
            } else {
                self.photos = []
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showErrorAlert()
                    })
                }
            }
        })
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
