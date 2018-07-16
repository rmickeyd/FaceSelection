//
//  UIViewExtensions.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/15/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /// Rotates view
    ///
    /// - Parameter angle: The angle to rotate the view by
    func rotate(_ angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
}
