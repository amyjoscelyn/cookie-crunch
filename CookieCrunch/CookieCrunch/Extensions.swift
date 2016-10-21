
//
//  Extensions.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

extension Dictionary
{
    //mostly boilerplate, loads specified object into an NSData object, then converts that to a Dictionary using the NSJSONSerializion API
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>?
    {
        var dataOK: Data
        var dictionaryOK: NSDictionary = NSDictionary()
        
        //If I need to organize my level.json files into a folder, prefix the folder's name to the filename, ie: "Levels//\(filename)" or earlier on when I'm setting the string for filename, just add "Levels/" to it then
        let pathtry = Bundle.main.path(forResource: filename, ofType: "json")
        if let path = pathtry
        {
            do
            {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
                print(data);
                dataOK = data!
                
            }
            catch
            {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            do
            {
                let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dictionaryOK = (dictionary as! NSDictionary as? Dictionary<String, AnyObject>)! as NSDictionary
            }
            catch
            {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        print("DictionaryOK count::::::::::\(dictionaryOK.count)")
        return dictionaryOK as? Dictionary<String, AnyObject>
    }
}
