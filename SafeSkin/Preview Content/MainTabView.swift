//
//  MainTabView.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/12/24.


import SwiftUI

struct InstructionsPopupView: View {
    @Binding var showInstructions: Bool
    
    var body: some View {
        VStack {
            Text("Welcome to SafeSkin!")
                .font(.headline)
                .padding(.top)
            
            Text("How to Use:")
                .font(.subheadline)
                .padding(.top, 5)
            
            Text("""
                1. Fill out your skin profile, including ingredients you want to look out for.
                
                2. Hit the Scan icon below to scan an ingredient label.
                
                3. SafeSkin will highlight all the ingredients you want to look out for in red!
                """)
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)
            
            Button(action: {
                showInstructions = false
            }) {
                Text("Got it!")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("sage"))
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(width: 300, height: 500)
    }
}

struct MainTabView: View {
    @StateObject var profileModel = ProfileModel() // shared one
    @State private var isShowingLoadingScreen: Bool = true
    @State private var showInstructions: Bool = true
    
    var body: some View {
        ZStack {
            if !isShowingLoadingScreen {
                ZStack {
                    TabView {
                        ProfileView(profileModel: profileModel)
                            .tabItem {
                                Image(systemName: "person.circle")
                                Text("Profile")
                            }
                        
                        ScanProductView(profileModel: profileModel)
                            .tabItem {
                                Image(systemName: "camera.viewfinder")
                                Text("Scan")
                            }
                    }
                    
                    if showInstructions {
                        InstructionsPopupView(showInstructions: $showInstructions)
                            .transition(.scale)
                    }
                }
                .animation(.easeInOut, value: showInstructions)
            } else {
                LoadingView(isShowingLoadingScreen: $isShowingLoadingScreen)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

