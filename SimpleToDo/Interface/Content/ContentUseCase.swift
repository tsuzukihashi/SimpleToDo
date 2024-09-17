//
//  ContentUseCase.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation

protocol ContentUseCaseInteractor {
    func fetch() throws -> ContentViewData
    func addItem(title: String) throws
    func deleteItem(id: String) throws
}

class ContentUseCase {
    private let coreDataService: any CoreDataServiceProtocol

    init(coreDataService: any CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
}

extension ContentUseCase: ContentUseCaseInteractor {
    func fetch() throws -> ContentViewData {
        let items = try coreDataService.fetchAllItem()
        return ContentViewDataTranslator.translate(items: items)
    }

    func addItem(title: String) throws {
        try coreDataService.addItem(title: title)
    }

    func deleteItem(id: String) throws {
        try coreDataService.deleteItem(id: id)
    }
}
