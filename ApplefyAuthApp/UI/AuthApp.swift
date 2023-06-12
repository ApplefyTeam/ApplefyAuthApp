//
//  ApplefyAuthAppApp.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

@main
struct AuthApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListOfTokensView()
                #if os(macOS)
//                    .frame(minWidth: 700, minHeight: 400)
//                    .presentedWindowToolbarStyle(.expanded)
                #endif
            }
        }
    }
}
