//
//  ContentConstracts.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation

enum ContentViewState {
    case initial
    case fetched(data: ContentViewData)
    case error(error: Error)
}

struct ContentViewData {
    var items: [DisplayItem]

    init(items: [DisplayItem]) {
        self.items = items
    }

    struct DisplayItem: Identifiable {
        var id: String
        var title: String
        var timestamp: Date
        var isComplet: Bool

        init(id: String, title: String, timestamp: Date, isComplet: Bool) {
            self.id = id
            self.title = title
            self.timestamp = timestamp
            self.isComplet = isComplet
        }
    }
}
