//
//  View+Extension.swift
//  ApplefyAuthApp
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

extension View {
    

    @ViewBuilder
    func navigationBarInline() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
    
    
}
