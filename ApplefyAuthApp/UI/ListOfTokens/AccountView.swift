//
//  AccountView.swift
//  ApplefyAuthApp
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

struct AccountView: View {
    @State var currentPassword: String?
    let token: PersistentToken
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(token: PersistentToken) {
        self.token = token
        refreshPass()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if !token.token.issuer.isEmpty {
                    Text(token.token.issuer)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                Text(currentPassword ?? "*** ***")
                    .font(.system(size: 20))
                
                if !token.token.name.isEmpty {
                    Text(token.token.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .onReceive(timer) { time in
            refreshPass()
        }
    }
    
    func refreshPass() {
        guard let pass = token.token.currentPassword else { return }
        let length: Int = token.token.generator.digits / 2
        let formattedString: String = pass.prefix(length) + " " + pass.suffix(length)
        currentPassword = formattedString
    }
}
