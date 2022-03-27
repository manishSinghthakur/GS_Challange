//
//  MainView.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI

struct MainView: View {
    @State var selectedView = 1
    
    init() {UITabBar.appearance().backgroundColor = UIColor.white}
    
    var body: some View {
        TabView(selection: $selectedView) {
            PictureOfTheDay()
                .navigationTitle(Text("Picture Of The Day"))
                .tabItem {
                    Label("Picture", systemImage:"photo.fill")
                }
                .tag(1)
            Favorite()
                .navigationTitle(Text("Favorite"))
                .tabItem {
                    Label("Favorite", systemImage:"star.fill")
                }
                .tag(2)
        }
    }
}
