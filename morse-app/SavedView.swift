//
//  SaveView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-18.
//

import SwiftUI

struct SavedView: View {
    
    @State private var shouldShowAddButton: Bool = false
    @State private var viewModel = SaveTextViewModel()
    let item: SaveText
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .toolbar {
                Button {
                    shouldShowAddButton.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
            .navigationTitle(Text("Saved"))
            .sheet(isPresented: $shouldShowAddButton) {
                SaveTextView { _ in }
            }
        }
    }
}

#Preview {
    SavedView(item: .empty)
}
