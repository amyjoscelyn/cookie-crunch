//
//  Level.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level
{
    fileprivate var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)

    func cookieAt(column: Int, row: Int) -> Cookie?
    {
        //if the assert fails, the app will crash.  The backtrace will point specifically to this unexpected condition, making it easy to resolve.  We can purposefully want the app to crash when we don't expect this problem to ever occur
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func shuffle() -> Set<Cookie>
    {
        return createInitialCookies()
    }
    
    private func createInitialCookies() -> Set<Cookie>
    {
        var set = Set<Cookie>()
        
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if tiles[column, row] != nil
                {
                    print("TILES ARE NOT NIL!!!!!!!!")
                    
                    let cookieType = CookieType.random()
                    
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    
                    set.insert(cookie)
                }
                else
                {
                    print("(\(column), \(row)) TILES ARE NILLLLLLLLL: \(tiles[column, row])")
                }
            }
        }
        return set
    }
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    func tileAt(column: Int, row: Int) -> Tile?
    {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    init(filename: String)
    {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename)
            else
        {
            print("=============== dictionary did not load")
            return
        }
        
        print("~~~~~~~~~~~~~~ dictionary tiles: \(dictionary)")
        
        guard let tilesArray = dictionary["tiles"] as? [[Int]]
            else
        {
            print("+++++++++++++++ tiles from dictionary did not load")
            return
        }
        
        for (row, rowArray) in tilesArray.enumerated()
        {
            let tileRow = NumRows - row - 1
            
            for (column, value) in rowArray.enumerated()
            {
                if value == 1
                {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }
}
