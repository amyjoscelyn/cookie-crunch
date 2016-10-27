//
//  Chain.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/22/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

class Chain: Hashable, CustomStringConvertible
{
    var cookies = [Cookie]()
    var score = 0
    
    enum ChainType: CustomStringConvertible
    {
        case horizontal
        case vertical
        case lShape
//        If you feel adventurous, you can also add more complex chain types, such as L- and T-shapes.
//        There is a reason you’re using an array here to store the cookie objects and not a Set: It’s convenient to remember the order of the cookie objects so that you know which cookies are at the ends of the chain. This makes it easier to combine multiple chains into a single one to detect those L- or T-shapes.
        
        var description: String {
            switch self
            {
            case .horizontal: return "Horizontal"
            case .vertical: return "Vertical"
            case .lShape: return "L-Shape"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType)
    {
        self.chainType = chainType
    }
    
    func addCookie(cookie: Cookie)
    {
        cookies.append(cookie)
    }
    
    func firstCookie() -> Cookie
    {
        return cookies[0]
    }
    
    func lastCookie() -> Cookie
    {
        return cookies[cookies.count - 1]
    }
    
    var length: Int {
        return cookies.count
    }
    
    var description: String {
        return "type:\(chainType) cookies:\(cookies)"
    }
    
    //Note: The chain implements Hashable so it can be placed inside a Set. The code for hashValue may look strange but it simply performs an exclusive-or on the hash values of all the cookies in the chain. The reduce() function is one of Swift’s more advanced functional programming features.
    var hashValue: Int {
        return cookies.reduce(0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool
{
    return lhs.cookies == rhs.cookies
}
