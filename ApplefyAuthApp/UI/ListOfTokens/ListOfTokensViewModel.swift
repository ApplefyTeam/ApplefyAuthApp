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
    @Published var isManualAdding: Bool = false
    
    @Published var isCopied: Bool = false
    
    
    func refresh() {
        isLoading = true
        withAnimation {
            tokens = AppManager.shared.store.persistentTokens
            isLoading = false
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { tokens[$0] }
        print(itemsToDelete)
        itemsToDelete.forEach {
            try? AppManager.shared.store.deletePersistentToken($0)
            refresh()
        }
    }
}
