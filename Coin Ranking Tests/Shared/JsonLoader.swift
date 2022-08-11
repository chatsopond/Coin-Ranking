//
//  JsonLoader.swift
//  LMWN Coin 2 Tests
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import XCTest
import Foundation

class JsonLoader {
    public static func stringFrom(for aClass: AnyClass, forResource filename: String, ofType ext: String = "json") -> String {
        guard let pathString = Bundle(for: aClass).path(forResource: filename, ofType: ext) else {
            fatalError("\(filename).\(ext) not found")
        }
        guard let jsonString = try? String(contentsOfFile: pathString) else {
            fatalError("can't init string from \(filename).\(ext)")
        }
        return jsonString
    }
}
