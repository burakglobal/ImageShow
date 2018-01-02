//
//  Extensions.swift
//  ImageShow
//
//  Created by Burak Kebapci on 1/2/18.
//  Copyright © 2018 Burak Kebapci. All rights reserved.
//

import Foundation
import UIKit

func initFromStoryboard(name: String, identifier: String) -> UIViewController {
    return UIStoryboard(name: name, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
}
public extension UIViewController {
    
    @IBAction func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    func open(viewController: UIViewController) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func pop(to viewController: AnyClass) {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller.isKind(of: viewController) {
                    navigationController.popToViewController(controller, animated: true)
                }
            }
        }
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    
    
}

extension String {
    var doubleValue: Double {
        return Double((self.replacingOccurrences(of: ",", with: ".") as NSString).doubleValue)
    }
}
