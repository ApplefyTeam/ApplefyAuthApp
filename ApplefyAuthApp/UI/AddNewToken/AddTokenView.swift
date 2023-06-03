//
//  AddTokenView.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

struct AddTokenView: View {
    @StateObject var viewModel: AddTokenViewModel = AddTokenViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("New Token")
        }
        .navigationTitle("Add new Token")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            #if os(macOS)
            #else
            ToolbarItem(placement: .navigationBarLeading, content: {
                NavBackButton(dismiss: self.dismiss)
            })
            #endif
        }
    }
}

struct AddTokenView_Previews: PreviewProvider {
    static var previews: some View {
        AddTokenView()
    }
}
