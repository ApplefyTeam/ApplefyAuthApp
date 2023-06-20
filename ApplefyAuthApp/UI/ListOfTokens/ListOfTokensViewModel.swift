//
//  ListOfTokensViewModel.swift
//  ApplefyAuthApp
//
//  Created by Denys on 03.06.2023.
//

import SwiftUI
import Combine

class ListOfTokensViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var tokens: [PersistentToken] = []
    @Published var isCopied: Bool = false
    private let tokenStore: TokenStoreProtocol!
    var observer: NSObjectProtocol?
    
    init(tokenStore: TokenStoreProtocol = AppManager.shared.store) {
        self.tokenStore = tokenStore
        self.observer = NotificationCenter.default.addObserver(forName: .refreshApplefyTokens,
                                                               object: nil, queue: nil,
                                                               using: { _ in })
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc
    @MainActor
    func refresh() async throws {
        isLoading = true
        try tokenStore.loadTokens()
        withAnimation {
            tokens = tokenStore.persistentTokens
            isLoading = false
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { tokens[$0] }
        itemsToDelete.forEach {
            try? tokenStore.deletePersistentToken($0)
        }
        Task {
            try? await refresh()
        }
    }
}
