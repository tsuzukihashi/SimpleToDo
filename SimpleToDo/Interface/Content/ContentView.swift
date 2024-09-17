//
//  ContentView.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: ContentViewModel = .init(
        useCase: ContentUseCase(
            coreDataService: CoreDataService.shared
        )
    )

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .initial:
                    initialView
                case .fetched(let data):
                    fetchedView(viewData: data)
                case .error(let error):
                    errorView(error)
                }
            }
            .navigationTitle("タスク")
            .toolbar { toolbar }
            addItemButton
        }
        .alert("新規作成", isPresented: $viewModel.showCreateItem) {
            TextField("TODOのタイトル", text: $viewModel.todoTitle)
            Button {
                viewModel.didTapSubmitButton()
            } label: {
                Text("作成")
            }
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }

    var initialView: some View {
        ProgressView()
    }

    func fetchedView(viewData: ContentViewData) -> some View {
        List {
            ForEach(viewData.items) { item in
                Text(item.title)
            }
        }
        .listStyle(.plain)
    }

    func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
            .foregroundStyle(.red)
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
            })

        }   
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {}, label: {
                Image(systemName: "ellipsis.circle")
                    .offset(y: 2)
            })
        }
    }

    var addItemButton: some View {
        Button(action: viewModel.didTapAddItemButton, label: {
            Label("新規", systemImage: "plus.circle.fill")
                .font(.headline)
                .foregroundStyle(.orange)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, CoreDataService.preview.container.viewContext)
}
