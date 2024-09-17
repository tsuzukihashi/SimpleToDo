//
//  ContentViewDataTranslator.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation

enum ContentViewDataTranslator {
    static func translate(items: [Item]) -> ContentViewData {
        ContentViewData(items: items.compactMap { item in
            guard let id = item.id, let title = item.title, let timestamp = item.timestamp else { return nil }
            return .init(id: id, title: title, timestamp: timestamp, isComplet: item.isComplete)
        })
    }
}
