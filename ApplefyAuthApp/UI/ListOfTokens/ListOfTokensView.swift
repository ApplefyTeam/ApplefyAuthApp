//
//  ListOfTokens.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

struct ListOfTokensView: View {
    @State var isLoading: Bool = false
    
    @State var tokens: [PersistentToken] = []
    @State var isManualAdding: Bool = false
    
    @State var isCopied: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .bold()
                
            } else if tokens.isEmpty {
                withAnimation {
                    VStack {
                        Text("No tokens!")
                            .font(.title)
                            .padding()
                    }
                }
            } else {
                content
            }
        }
        .toolbar {
            HStack {
                Button(action: refresh, label: {
                    Image(systemName: "arrow.clockwise")
                        .tint(.black)
                })
                
                Button(action: {
                    isManualAdding.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .tint(.black)
                })
                
                NavigationLink(destination: {
                    ScanTokenView()
                }, label: {
                    Image(systemName: "camera")
                        .tint(.black)
                })
            }
        }
        .navigationDestination(isPresented: $isManualAdding, destination: {
            AddTokenView()
        })
        .navigationTitle("Accounts List")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear {
            refresh()
        }
        .alert(isPresented: $isCopied) {
                    Alert(title: Text("Code copied!"),
                          message: Text("You can now paste and use it."),
                          dismissButton: .default(Text("OK")))
                }
    }
    
    var content: some View {
        VStack {
            List {
                ForEach(tokens, id: \.identifier) { token in
                    AccountView(token: token)
                        .onTapGesture {
                            UIPasteboard.general.string = token.token.currentPassword
                            isCopied = true
                        }
                }
                .onDelete(perform: deleteItem)
            }
            .cornerRadius(20)
        }
    }
    
    func refresh() {
        isLoading = true
        withAnimation {
            self.tokens = AppManager.shared.store.persistentTokens
            isLoading = false
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { tokens[$0] }
        print(itemsToDelete)
        itemsToDelete.forEach {
            try? AppManager.shared.store.deletePersistentToken($0)
            refresh()
        }
    }
}

struct ListOfTokens_Previews: PreviewProvider {
    static var previews: some View {
        ListOfTokensView()
    }
}
