//
//  AddTokenView.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI

struct AddTokenView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("New Token")
        }
        .navigationTitle("Add new Token")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                NavBackButton(dismiss: self.dismiss)
            })
        }
    }
}

struct AddTokenView_Previews: PreviewProvider {
    static var previews: some View {
        AddTokenView()
    }
}
