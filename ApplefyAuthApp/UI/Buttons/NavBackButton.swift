//
//  NavBackButton.swift
//  ApplefyAuthApp
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

struct NavBackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
                .tint(.black)
        }
    }
}
