//
//  Helpers.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 17.09.2023.
//

import Foundation
import WebKit

final class Helpers{
    static func cleanCoockies() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {}
                )
            }
        }
    }
    
}
