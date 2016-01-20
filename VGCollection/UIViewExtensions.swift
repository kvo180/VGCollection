//
//  UIViewExtensions.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/20/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(duration: NSTimeInterval = 0.4, delay: NSTimeInterval = 0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
            self.alpha = 1
            }, completion: completion)
    }
}
