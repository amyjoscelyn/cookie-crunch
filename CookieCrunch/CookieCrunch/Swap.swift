//
//  Swap.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/21/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

struct Swap: CustomStringConvertible, Hashable
{
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie)
    {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var hashValue: Int {
        return cookieA.hashValue ^ cookieB.hashValue //exclusive-or operator
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool
{
    return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB)
        || (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}
