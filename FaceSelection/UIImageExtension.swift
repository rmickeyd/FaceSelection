//
//  UIImageExtension.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/14/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Saves image to document directory
    ///
    /// - Parameters:
    ///   - name: The name of the file
    ///   - type: The type of file
    func saveToDocumentDirectory(_ name: String, _ type: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let fileManager = FileManager.default
        let imagePath = "\(documentsDirectory)/\(name).\(type)"
        
        if !fileManager.fileExists(atPath: imagePath) {
            let imageData = UIImageJPEGRepresentation(self, 1.0)
            fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        }
        
    }
    
}
