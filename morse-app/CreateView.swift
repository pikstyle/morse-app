//
//  CreateView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-18.
//

import SwiftUI

struct CreateView: View {
    
    @State private var title: String = ""
    
    @State private var text: String = ""
    @State var dateOfCreation: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
        
                Section(header: Text("Basics informations ")) {
                    
                    TextField("Tilte", text: $title)
                    DatePicker("Date", selection: $dateOfCreation, displayedComponents: .date)
                }
                
                Section(header: Text("Text")) {
                    TextEditor(text: $text)
                }
                
            }
            .navigationTitle("Create")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // action
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // action
                    }
                }
            }
        }
    }
}

#Preview {
    CreateView()
}
