//
//  ListOfTokens.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

struct ListOfTokens: View {
    @State var tokens: [PersistentToken] = []
    
    var body: some View {
        VStack {
            Text("No tokens!")
//            tokens.forEach({
//                Text("Token \($0.)")
//            })
        }
        .navigationTitle("Accounts List")
        .padding()
    }
}

struct ListOfTokens_Previews: PreviewProvider {
    static var previews: some View {
        ListOfTokens()
    }
}
