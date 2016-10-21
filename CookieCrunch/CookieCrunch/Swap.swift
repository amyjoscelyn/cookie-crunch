//
//  Swap.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/21/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

struct Swap: CustomStringConvertible
{
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie)
    {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}
