//
//  FaceMetaData.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/12/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import ChameleonFramework

struct FaceMetaDataIdentifiers {
    static let faceId = "faceId"
    static let faceRectangle = "faceRectangle"
    static let faceAttributes = "faceAttributes"
    static let faceLandmarks = "faceLandmarks"
}

class FaceMetaData: NSObject {
    
    var faceID: String
    var faceRectangle: CGRect
    var faceAttributes: FaceAttributes
    var faceLandmarks: [CGPoint]
    
    init(faceID: String, faceRectangle: CGRect, faceAttributes: FaceAttributes, faceLandmarks: [CGPoint]) {
        self.faceID = faceID
        self.faceRectangle = faceRectangle
        self.faceAttributes = faceAttributes
        self.faceLandmarks = faceLandmarks
    }
    
    
    /// Loads FaceMetaData from server
    ///
    /// - Parameters:
    ///   - urlString: String representation of URL to call
    ///   - completion: Completion block to pass FaceMetaData
    static func loadFaceMetaData(for urlString: String, completion: @escaping (_ metaData: [FaceMetaData], _ error: String?) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion([], "Invalid URL")
            return
        }
        
        Alamofire.request(url, method: .get).responseJSON { (res) in
            guard let response = res.result.value else {
                completion([], res.error?.localizedDescription ?? "Something went wrong")
                return
            }
            
            let json = JSON(response)
            
            guard let jsonArray = json.array else {
                completion([], res.error?.localizedDescription ?? "Something went wrong")
                return
            }
            
            FaceMetaData.saveFaceMetaData(json.arrayObject!, "face_metadata", type: "json")
            
            var metaData: [FaceMetaData] = []
            
            for item in jsonArray {
                guard let dict = item.dictionaryObject,
                    let newMetaData = FaceMetaData.parseFaceMetaData(dict) else {
                    continue
                }
                metaData.append(newMetaData)
            }
            
            completion(metaData, nil)
            
        }
    }
    
    
    /// Initializes FaceMetaDataObject
    ///
    /// - Parameter data: Dictionary representation of FaceMetaData object
    /// - Returns: Initialized FaceMetaData object
    fileprivate static func parseFaceMetaData(_ data: [String : Any]) -> FaceMetaData? {
        
        let faceID = data[FaceMetaDataIdentifiers.faceId] as? String ?? ""
        var top = 0
        var left = 0
        var w = 0
        var height = 0
        if let faceRect = data[FaceMetaDataIdentifiers.faceRectangle] as? [String : Any] {
            for (_,k) in faceRect.enumerated() {
                let value = k.value as? Int ?? 0
                switch k.key {
                case "top": left = value
                case "left": top = value
                case "width": w = value
                case "height": height = value
                default: continue
                }
            }
        }
        let faceRect = CGRect(x: top, y: left, width: w, height: height)
        
        let faceAttributesDict = data[FaceMetaDataIdentifiers.faceAttributes] as? [String : Any] ?? [:]
        let faceAttributes = FaceAttributes.parseFaceAttributes(faceAttributesDict)
        
        var faceLandmarks: [CGPoint] = []
        
        if let landmarks = data[FaceMetaDataIdentifiers.faceLandmarks] as? [String : AnyObject] {
            
            for (_,j) in landmarks.enumerated() {
                
                let x = j.value["x"] as? Double ?? 0.0
                let y = j.value["y"] as? Double ?? 0.0
                
                let newPoint = CGPoint(x: x, y: y)
                
                faceLandmarks.append(newPoint)
                
            }
            
        }
        
        let faceMetaData = FaceMetaData(faceID: faceID, faceRectangle: faceRect, faceAttributes: faceAttributes, faceLandmarks: faceLandmarks)
        
        return faceMetaData
    }
    
    
    /// Gets the UIView (UIButton) representing the Face Rectangle
    ///
    /// - Parameter scale: Scale of image based on displayed image size
    /// - Returns: UIView that will encompass the face
    func getFaceBox(_ scale: CGFloat) -> UIButton {
        let view = UIButton()
        
        let x = self.faceRectangle.origin.x / scale
        let y = self.faceRectangle.origin.y / scale
        let width = self.faceRectangle.width / scale
        let height = self.faceRectangle.height / scale
        
        view.frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.layer.borderWidth = 2.0
        
        if self.faceAttributes.gender == .male {
            view.layer.borderColor = UIColor.flatBlue.cgColor
        } else {
            view.layer.borderColor = UIColor.flatPink.cgColor
        }
        
        return view
    }
    
    
    /// Gets green dot views representing face landmarks
    ///
    /// - Parameter scale: Scale of image based on displayed image size
    /// - Returns: Array of green views representing face landmarks
    func getFaceLandmarks(_ scale: CGFloat) -> [UIView] {
        
        var views: [UIView] = []
        
        for landmark in faceLandmarks {
            let view = UIView()
            view.backgroundColor = UIColor.flatGreen
            let newX = landmark.x / scale
            let newY = landmark.y / scale
            
            view.frame = CGRect(x: newX, y: newY, width: 2.0, height: 2.0)
            view.layer.cornerRadius = view.frame.width / 2
            
            views.append(view)
            
        }
        
        return views
        
    }
    
    
    /// Saves FaceMetaData json file to document directory
    ///
    /// - Parameters:
    ///   - data: JSON data to save
    ///   - name: Name of file to save
    ///   - type: Tpe of file to save
    static func saveFaceMetaData(_ data: Any, _ name: String, type: String) {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            
            let fileManager = FileManager.default
            let filePath = "\(documentsDirectory)/\(name).\(type)"
            
            if !fileManager.fileExists(atPath: filePath) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let string = String(data: jsonData, encoding: .utf8) ?? ""
                    try string.write(toFile: filePath, atomically: true, encoding: .utf8)
                } catch {
                    return
                }
            }
            
        
    }
    
}
