//
//  Save.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-22.
//

import Foundation

struct SaveText: Identifiable {
    let id = UUID()
    var general: General
}

extension SaveText {
    struct General {
        var title: String
        var date: Date
        var text: String
    }
}

extension SaveText {
    static var empty: SaveText {
        let general = SaveText.General(title: "", date: Date(), text: "")
        return SaveText(general: general)
    }
}
