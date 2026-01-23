//
//  CreateView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-18.
//

import SwiftUI

struct SaveTextView: View {
    
    @Environment(\.dismiss) private var dismiss // directement enlever n'importe quelle vue
    @Environment(\.presentationMode) private var presentationMode // idem mais pour ios plus bas
    
    @State private var viewModel = SaveTextViewModel() // Obtenir les variables depuis le modèle "Save"
    let action: (_ save: SaveText) -> Void
    
    @State private var title: String = ""
    
    @State private var text: String = ""
    @State var dateOfCreation: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                general
            }
            .navigationTitle("Create")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        action(viewModel.saveText)
                        handleDismiss()
                    }
                    .disabled(!viewModel.isValid) // désactiver le bouton si aucune données ne sont remplies
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        handleDismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SaveTextView { _ in }
}

private extension SaveTextView {
    @ViewBuilder
    var general: some View {
        Section(header: Text("Basics informations ")) {
            
            TextField("Tilte", text: $viewModel.saveText.general.title) // Prendre les variables depuis le viewModel
            DatePicker("Date", selection: $viewModel.saveText.general.date, displayedComponents: .date)
        }
        
        Section(header: Text("Text")) {
            TextEditor(text: $viewModel.saveText.general.text)
        }
    }
}

private extension SaveTextView {
    
    // gérer le dismiss en fonction de la version d'IOS
    
    func handleDismiss() {
        if #available(iOS 15, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
