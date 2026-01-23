//
//  MainView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-18.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TranslateView()
                .tabItem {
                    Label("Translate", systemImage: "pencil")
                }
            
            SavedView(item: .empty)
                .tabItem {
                    Label("Save", systemImage: "doc.text")
                }
        }
    }
}

#Preview {
    MainView()
}
