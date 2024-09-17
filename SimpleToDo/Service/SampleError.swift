//
//  SampleError.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation

enum SampleError: LocalizedError {
    case missingItemID

    var errorDescription: String? {
        switch self {
        case .missingItemID:
            "指定されたIDが見つかりませんでした"
        }
    }
}
