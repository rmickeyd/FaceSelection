//
//  UIImageViewExtensions.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/12/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    
    /// Download image from network
    ///
    /// - Parameters:
    ///   - urlString: The URL of the image
    ///   - defaultImage: The placeholder image to be displayed during download
    ///   - completion: Do something with downloaded image
    func imageFromServerURL(urlString: String, defaultImage: UIImage, completion: @escaping (_ image: UIImage?) -> ()) {
        
        self.image = defaultImage
        
        guard let url = URL(string: urlString) else {
            completion(defaultImage)
            return
        }
        
        Alamofire.request(url).responseImage { (response) in
            if let img = response.result.value {
                img.saveToDocumentDirectory("image", "jpg")
                self.image = img
                completion(img)
            }
        }
        
    }
    
}

