//
//  String+Extensions.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 16.09.2023.
//

import Foundation


extension String {
    public func formatISODateString() -> String? {
        var formatDate = self
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            formatDate = dateFormatter.string(from: date)
        }
        return formatDate
    }
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
