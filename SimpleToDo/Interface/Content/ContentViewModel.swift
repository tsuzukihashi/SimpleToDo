//
//  ContentViewModel.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation

@Observable
class ContentViewModel {
    private let useCase: any ContentUseCaseInteractor
    var viewState: ContentViewState = .initial

    var showCreateItem: Bool = false
    var todoTitle: String = ""
    // Error
    var showError: Bool = false
    var errorMsg: String = ""

    init(useCase: any ContentUseCaseInteractor) {
        self.useCase = useCase
    }

    func onAppear() {
        fetch()
    }

    func didTapAddItemButton() {
        showCreateItem = true
    }

    func didTapSubmitButton() {
        do {
            try useCase.addItem(title: todoTitle)
            resetStatus()
            fetch()
        } catch {
            showError(message: error.localizedDescription)
        }
    }

    func didTapComplete(id: String) {
        do {
            try useCase.deleteItem(id: id)
        } catch {
            showError(message: error.localizedDescription)
        }
    }
}

extension ContentViewModel {
    private func fetch() {
        do {
            let viewData = try useCase.fetch()
            viewState = .fetched(data: viewData)
        } catch {
            viewState = .error(error: error)
        }
    }

    private func resetStatus() {
        todoTitle = ""
    }

    private func showError(message: String) {
        errorMsg = message
        showError = true
    }
}
