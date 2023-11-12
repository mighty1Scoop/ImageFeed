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
}
