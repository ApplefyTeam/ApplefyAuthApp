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
                Text(currentPassword ?? "*** ***")
                    .font(.headline)
                
                Text(token.token.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
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
        let length: Int = (pass.count + 1) / 2
        let formattedString: String = pass.prefix(length) + " " + pass.suffix(length)
        currentPassword = formattedString
    }
}
