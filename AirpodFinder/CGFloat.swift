//
//  CGFloat.swift
//  AirpodFinder
//
//  Created by johnrhickey on 12/27/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    var toRad: CGFloat {
        get {
            return self * (CGFloat.pi / 180)
        }
    }
}
