//
//  GS_CodingChallengeApp.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI

@main
struct GS_CodingChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().modifier(DarkModeViewModifier())
        }
    }
}

public struct DarkModeViewModifier: ViewModifier {
@AppStorage("isDarkMode") var isDarkMode: Bool = true
public func body(content: Content) -> some View {
    content
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
