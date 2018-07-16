//
//  MainViewController.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/11/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var faceBoxes: [UIView] = []
    var landMarkViews: [[UIView]] = []
    var selectedIndex: Int? = nil
    var metaData: [FaceMetaData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = nil
        self.textView.text = nil
        
        // Image URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family.jpg
        // JSON URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family_faces.json
        // JSON contents documentation: https://westus.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236
        
        // TODO: Start your project here
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        reloadTextView()
        loadImage()
    
    }
    
    
    /// Loads the image asynchronously from server
    /// Displays placeholder image during request
    func loadImage() {
        self.imageView.imageFromServerURL(urlString: ServerHelper.imageURL, defaultImage: #imageLiteral(resourceName: "placeHolderImage")) { (image) in
            
            guard let im = image else {
                return
            }
        
            self.imageView.image = image
            
            let scale = (im.size.width * im.scale) / self.imageView.frame.width
            
            self.layoutFaceContainerView(scale)
            
        }
    }
    
    
    /// Lays out the views that are displayed over faces
    ///
    /// - Parameter scale: Scale of image based on displayed image size
    func layoutFaceContainerView(_ scale: CGFloat) {
        FaceMetaData.loadFaceMetaData(for: ServerHelper.jsonURL) { (faceMetaData, error) in
            
            for face in faceMetaData {
                let view = face.getFaceBox(scale)
                view.rotate(CGFloat(face.faceAttributes.headPose.roll))
                self.faceBoxes.append(view)
                self.metaData.append(face)
                self.landMarkViews.append(face.getFaceLandmarks(scale))
                self.imageView.addSubview(view)
                view.isUserInteractionEnabled = true
                view.addTarget(self, action: #selector(self.faceViewTapped(sender:)), for: .touchUpInside)
                
            }
            
        }
    }
    
    /// Reloads face views
    func reloadViews() {
        
        removeLandmarkViews()
        
        for view in faceBoxes {
            view.layer.borderWidth = 2.0
        }
        
        if let index = selectedIndex {
            let view = faceBoxes[index]
            view.layer.borderWidth = 5.0
            
            let landmarks = landMarkViews[index]
            
            for view in landmarks {
                self.imageView.addSubview(view)
            }
            
        }
        
        self.view.layoutIfNeeded()
        reloadTextView()
        
    }
    
    
    /// Handles taps on the image view
    /// Cancels any face view selections
    func imageTapped(gesture: UITapGestureRecognizer) {
        selectedIndex = nil
        reloadViews()
    }
    
    /// Handles Face view taps
    func faceViewTapped(sender: UIButton) {
        for i in 0..<faceBoxes.count {
            if faceBoxes[i] === sender {
                
                if i == selectedIndex {
                    selectedIndex = nil
                } else {
                    
                    selectedIndex = i
                }
                
                break
            }
        }
        
        

        
        reloadViews()
    }
    
    /// Reloads text view and shows appropriate data
    func reloadTextView() {
        if let index = selectedIndex {
            let data = metaData[index].faceAttributes
            
            
            
            let percentArea = round((faceBoxes[index].frame.width / self.imageView.image!.size.width) * 1000) / 10
            
            textView.text = "Gender: \(data.gender)\nAge: \(data.age)\nEmotion: \(data.getMostConfidentEmotion())\n% Area To Photo: \(percentArea)%"
        } else {
            textView.text = "NO FACE SELECTED"
        }
    }
    
    /// Removes Green Landmark views
    func removeLandmarkViews() {
        for view in self.imageView.subviews {
            if view.backgroundColor == UIColor.flatGreen {
                view.removeFromSuperview()
            }
        }
    }

}
