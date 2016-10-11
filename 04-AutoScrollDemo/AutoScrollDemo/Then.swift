//
//  Then.swift
//  AutoScrollDemo
//
//  Created by 冯志浩 on 16/10/8.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

public protocol Then {}

extension Then where Self: Any {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then( block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

extension Then where Self: AnyObject {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then( block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
