//
//  ScanTokenView.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct ScanTokenView: View {
    @StateObject private var model = ScanTokenViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            FrameView(image: model.frame)
                .edgesIgnoringSafeArea(.all)
            
            CameraErrorView(error: model.error)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                NavBackButton(dismiss: self.dismiss)
            })
        }
    }
}

struct FrameView: View {
    var image: CGImage?
    var error: Error?
    private let label = Text("Scan Token View")
    
    var body: some View {
        if let image = image {
            GeometryReader { geometry in
                Image(image, scale: 1.0, orientation: .upMirrored, label: label)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
            }
        } else {
            Color.black
        }
    }
}

struct CameraErrorView: View {
    var error: Error?
    
    var body: some View {
        VStack {
            Text(error?.localizedDescription ?? "")
                .bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(8)
                .foregroundColor(.white)
                .background(Color.red.edgesIgnoringSafeArea(.top))
                .opacity(error == nil ? 0.0 : 1.0)
                .animation(.easeInOut, value: 0.25)
            
            Spacer()
        }
    }
}

struct ScanTokenView_Previews: PreviewProvider {
    static var previews: some View {
        ScanTokenView()
    }
}
