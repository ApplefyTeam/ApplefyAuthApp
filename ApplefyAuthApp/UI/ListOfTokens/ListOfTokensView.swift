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
    @State var isScanning: Bool = false
    @State var isManualAdding: Bool = false
    
    init() {
        refresh()
    }
    
    var body: some View {
        ZStack {
            content
            
            if tokens.isEmpty {
                withAnimation {
                    Text("No tokens!")
                }
            }
            
            if isLoading {
                ProgressView()
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
                
//                Spacer(minLength: 25)
                
                Button(action: {
                    isScanning.toggle()
                }, label: {
                    Image(systemName: "camera.circle.fill")
                        .tint(.black)
                })
            }
        }
        .navigationDestination(isPresented: $isScanning, destination: {
            ScanTokenView()
        })
        .navigationDestination(isPresented: $isManualAdding, destination: {
            AddTokenView()
        })
        .navigationTitle("Accounts List")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .refreshable {
            refresh()
        }
    }
    
    var content: some View {
        VStack {
            ForEach(tokens, id: \.identifier) { token in
                Text("Token \(token.token.name)")
            }
        }
    }
    
    func refresh() {
        isLoading = true
        withAnimation {
            self.tokens = AppManager.shared.store.persistentTokens
            isLoading = false
        }
    }
}

struct ListOfTokens_Previews: PreviewProvider {
    static var previews: some View {
        ListOfTokensView()
    }
}
