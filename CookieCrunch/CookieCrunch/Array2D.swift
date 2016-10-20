//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

struct Array2D<T> //struct is a 'generic' – it can hold elements of any type T
{
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int)
    {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get
        {
            return array[row * columns + column]
        }
        set
        {
            array[row * columns + column] = newValue
        }
    }
}
