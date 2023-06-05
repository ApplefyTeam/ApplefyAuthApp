//
//  ListOfTokens.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

struct ListOfTokensView: View {
    @StateObject var viewModel: ListOfTokensViewModel = ListOfTokensViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .bold()
                
            } else if viewModel.tokens.isEmpty {
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
                Button(action: refreshTokens, label: {
                    Image(systemName: "arrow.clockwise")
                        .tint(.black)
                })
                
                NavigationLink(destination: {
                    AddTokenView()
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
        .padding()
        .navigationTitle("Accounts List")
        .onAppear {
            refreshTokens()
        }
        .alert(isPresented: $viewModel.isCopied) {
                    Alert(title: Text("Code copied!"),
                          message: Text("You can now paste and use it."),
                          dismissButton: .default(Text("OK")))
                }
        .navigationBarInline()
    }
    
    var content: some View {
        VStack {
            List {
                ForEach(viewModel.tokens, id: \.identifier) { token in
                    Button(action: {
                        guard let password = token.token.currentPassword else { return }
                        #if os(macOS)
                        NSPasteboard.general.setString(password, forType: .string)
                        #else
                        UIPasteboard.general.string = password
                        #endif
                        viewModel.isCopied = true
                    }, label: { AccountView(token: token) })
                    .buttonStyle(ListButtonStyle())
                }
                .onDelete(perform: viewModel.deleteItem)
            }
            .cornerRadius(20)
        }
    }
    
    private func refreshTokens() {
        Task {
            do {
                try await viewModel.refresh()
            } catch {
                print("Failed to refresh tokens \(error)")
            }
        }
    }
}

struct ListOfTokens_Previews: PreviewProvider {
    static var previews: some View {
        ListOfTokensView()
    }
}

struct ListButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
    }
}
