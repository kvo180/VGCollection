//
//  UIViewExtensions.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/20/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.4, delay: TimeInterval = 0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1
            }, completion: completion)
    }
}
