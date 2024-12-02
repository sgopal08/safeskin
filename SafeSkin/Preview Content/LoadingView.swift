//
//  LoadingScreen.swift
//  SafeSkin
//
//  Created by Sanjana G on 12/1/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isShowingLoadingScreen: Bool
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color("sage")
                .ignoresSafeArea()
            
            VStack {
                Image("LoadingPic")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Text("Loading...")
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 5)
                        .foregroundColor(.gray.opacity(0.3))
                        .cornerRadius(2.5)
                    
                    Rectangle()
                        .frame(width: progress, height: 5)
                        .foregroundColor(.black)
                        .cornerRadius(2.5)
                        .animation(.linear(duration: 2.0), value: progress)
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            startLoading()
        }
    }
    
    private func startLoading() {
        DispatchQueue.main.async {
            // Animate the loading bar
            withAnimation {
                progress = UIScreen.main.bounds.width - 80 // Full width minus padding
            }
            
            // Simulate loading delay before transitioning
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isShowingLoadingScreen = false
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowingLoadingScreen: .constant(true))
    }
}


#Preview {
    LoadingView(isShowingLoadingScreen: .constant(true))
}
