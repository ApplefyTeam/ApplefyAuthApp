//
//  ApplefyAuthAppApp.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

@main
struct ApplefyAuthAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListOfTokensView()
            }
        }
    }
}
