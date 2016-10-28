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
let NumLevels = 7 // Excludes level 0 in count

class Level
{
    fileprivate var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)
    private var possibleSwaps = Set<Swap>()
    
    var targetScore = 0
    var maximumMoves = 0
    private var comboMultiplier = 0

    func cookieAt(column: Int, row: Int) -> Cookie?
    {
        //if the assert fails, the app will crash.  The backtrace will point specifically to this unexpected condition, making it easy to resolve.  We can purposefully want the app to crash when we don't expect this problem to ever occur
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func shuffle() -> Set<Cookie>
    {
        var set: Set<Cookie>
        repeat
        {
            set = createInitialCookies()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        
        return set
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
                    var cookieType: CookieType
                    repeat
                    {
                        cookieType = CookieType.random()
                    } while (column >= 2
                        && cookies[column - 1, row]?.cookieType == cookieType
                        && cookies[column - 2, row]?.cookieType == cookieType)
                        || (row >= 2
                            && cookies[column, row - 1]?.cookieType == cookieType
                            && cookies[column, row - 2]?.cookieType == cookieType)
                    
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    
                    set.insert(cookie)
                }
            }
        }
        return set
    }
    
    private func hasChainAt(column: Int, row: Int) -> Bool
    {
        let cookieType = cookies[column, row]!.cookieType
        
        // Horizontal Chain Check
        var horzLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && cookies[i, row]?.cookieType == cookieType
        {
            i -= 1
            horzLength += 1
        }
        
        // Right
        i = column + 1
        while i < NumColumns && cookies[i, row]?.cookieType == cookieType
        {
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        
        // Vertical Chain Check
        var vertLength = 1
        
        // Down
        i = row - 1
        while i >= 0 && cookies[column, i]?.cookieType == cookieType
        {
            i -= 1
            vertLength += 1
        }
        
        // Up
        i = row + 1
        while i < NumRows && cookies[column, i]?.cookieType == cookieType
        {
            i += 1
            vertLength += 1
        }
        return vertLength >= 3
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
            else { return }
        
        guard let tilesArray = dictionary["tiles"] as? [[Int]]
            else { return }
        
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
        
        targetScore = dictionary["targetScore"] as! Int
        maximumMoves = dictionary["moves"] as! Int
    }
    
    func performSwap(swap: Swap)
    {
        let columnA = swap.cookieA.column
        let rowA = swap.cookieA.row
        let columnB = swap.cookieB.column
        let rowB = swap.cookieB.row
        
        cookies[columnA, rowA] = swap.cookieB
        swap.cookieB.column = columnA
        swap.cookieB.row = rowA
        
        cookies[columnB, rowB] = swap.cookieA
        swap.cookieA.column = columnB
        swap.cookieA.row = rowB
    }
    
    func detectPossibleSwaps()
    {
        var set = Set<Swap>()
        
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if let cookie = cookies[column, row]
                {
                    // Is it possible to swap this cookie with the one on its right?
                    if column < NumColumns - 1
                    {
                        // Have a cookie in this spot?  No tile, no cookie.
                        if let other = cookies[column + 1, row]
                        {
                            // Swap them
                            cookies[column, row] = other
                            cookies[column + 1, row] = cookie
                            
                            // Is either cookie now part of a chain?
                            if hasChainAt(column: column + 1, row: row) || hasChainAt(column: column, row: row)
                            {
                                set.insert(Swap(cookieA: cookie, cookieB: other))
                            }
                            
                            // Swap them back
                            cookies[column, row] = cookie
                            cookies[column + 1, row] = other
                        }
                    }
                    
                    if row < NumRows - 1
                    {
                        if let other = cookies[column, row + 1]
                        {
                            cookies[column, row] = other
                            cookies[column, row + 1] = cookie
                            
                            // Is either cookie now part of a chain?
                            if hasChainAt(column: column, row: row + 1) || hasChainAt(column: column, row: row)
                            {
                                set.insert(Swap(cookieA: cookie, cookieB: other))
                            }
                            
                            // Swap them back
                            cookies[column, row] = cookie
                            cookies[column, row + 1] = other
                        }
                    }
                }
            }
        }
        possibleSwaps = set
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool
    {
        return possibleSwaps.contains(swap)
    }
    
    private func detectHorizontalMatches() -> Set<Chain>
    {
        var set = Set<Chain>()
        
        for row in 0..<NumRows
        {
            var column = 0
            while column < NumColumns - 2 //no need to check the final two rows--need three for a chain
            {
                if let cookie = cookies[column, row]
                {
                    let matchType = cookie.cookieType
                    
                    if cookies[column + 1, row]?.cookieType == matchType &&
                        cookies[column + 2, row]?.cookieType == matchType
                    {
                        let chain = Chain(chainType: .horizontal)
                        repeat
                        {
                            chain.addCookie(cookie: cookies[column, row]!)
                            column += 1
                        } while column < NumColumns && cookies[column, row]?.cookieType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        return set
    }
    
    private func detectVerticalMatches() -> Set<Chain>
    {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns
        {
            var row = 0
            while row < NumRows - 2
            {
                if let cookie = cookies[column, row]
                {
                    let matchType = cookie.cookieType
                    
                    if cookies[column, row + 1]?.cookieType == matchType && cookies[column, row + 2]?.cookieType == matchType
                    {
                        let chain = Chain(chainType: .vertical)
                        repeat
                        {
                            chain.addCookie(cookie: cookies[column, row]!)
                            row += 1
                        } while row < NumRows && cookies[column, row]?.cookieType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    /*func detectLShapeMatches(horizontalChains: Set<Chain>, verticalChains: Set<Chain>) -> Set<Chain>
    {
        // An L-shape consists of two chains, one horizontal and one vertical, that share a corner cookie. You can loop through the set of horizontal chains and check if the chain’s first or last cookie is also present in any of the vertical chains. If so, remove those two chains and combine them into a new one, with a new ChainType.
        
        var set = Set<Chain>()
        
        for horzChain in horizontalChains
        {
            let firstCookie = horzChain.firstCookie()
            let lastCookie = horzChain.lastCookie()
            
            for vertChain in verticalChains
            {
                if vertChain.cookies.contains(firstCookie) || vertChain.cookies.contains(lastCookie)
                {
                    let newChain = Chain(chainType: .lShape)
                    
                    let horzCookies = horzChain.cookies
                    let vertCookies = vertChain.cookies
                    
                    newChain.cookies = horzCookies + vertCookies
                    
                    set.insert(newChain)
                }
            }
            //combine chains into new l-shape chain, add to set
            //remove vertchain, remove horzchain from parent sets
            //return l-shape chains
        }
        return set
    }*/
    
    func removeMatches() -> Set<Chain>
    {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        removeCookies(chains: horizontalChains)
        removeCookies(chains: verticalChains)
        
        calculateScores(for: horizontalChains)
        calculateScores(for: verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    private func removeCookies(chains: Set<Chain>)
    {
        for chain in chains
        {
            for cookie in chain.cookies
            {
                cookies[cookie.column, cookie.row] = nil
                //Note: At this point, the Chain object is the only owner of the Cookie object. When the chain gets deallocated, so will these cookie objects.
            }
        }
    }
    
    func fillHoles() -> [[Cookie]]
    {
        var columns = [[Cookie]]()
        
        for column in 0..<NumColumns
        {
            var array = [Cookie]()
            for row in 0..<NumRows
            {
                if tiles[column, row] != nil && cookies[column, row] == nil
                {
                    for lookup in (row + 1)..<NumRows
                    {
                        if let cookie = cookies[column, lookup]
                        {
                            cookies[column, lookup] = nil
                            cookies[column, row] = cookie
                            cookie.row = row
                            
                            array.append(cookie)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty
            {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpCookies() -> [[Cookie]]
    {
        var columns = [[Cookie]]()
        var cookieType: CookieType = .unknown
        
        for column in 0..<NumColumns
        {
            var array = [Cookie]()
            
            var row = NumRows - 1
            while row >= 0 && cookies[column, row] == nil
            {
                if tiles[column, row] != nil
                {
                    var newCookieType: CookieType
                    repeat
                    {
                        newCookieType = CookieType.random()
                    } while newCookieType == cookieType
                    cookieType = newCookieType
                    
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    array.append(cookie)
                }
                row -= 1
            }
            if !array.isEmpty
            {
                columns.append(array)
            }
        }
        return columns
    }
    
    private func calculateScores(for chains: Set<Chain>)
    {
        // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, and so on
        for chain in chains
        {
            chain.score = 60 * (chain.length - 2) * comboMultiplier
            comboMultiplier += 1
        }
    }
    
    func resetComboMultiplier()
    {
        comboMultiplier = 1
    }
}
