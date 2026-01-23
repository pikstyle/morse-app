//
//  SaveViewModel.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-22.
//

import Foundation
internal import Combine

@Observable final class SaveTextViewModel {
    var saveText: SaveText = .empty // mettre les données en empty de base
    
    var isValid: Bool {
        !saveText.general.title.isEmpty &&
        !saveText.general.text.isEmpty
    }
}
