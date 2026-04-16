//
//  AISite.swift
//  mmaipad
//
//  Created by loveliness on 2026/4/16.
//

import Foundation

struct AISite: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var urlString: String

    init(id: UUID = UUID(), name: String, urlString: String) {
        self.id = id
        self.name = name
        self.urlString = urlString
    }
}

extension AISite {
    static let builtIns: [AISite] = [
        AISite(name: "Google AI Studio", urlString: "https://aistudio.google.com/"),
        AISite(name: "豆包", urlString: "https://www.doubao.com/"),
        AISite(name: "DeepSeek", urlString: "https://chat.deepseek.com/"),
        AISite(name: "Monica", urlString: "https://monica.im/"),
        AISite(name: "GPT", urlString: "https://chat.openai.com/"),
        AISite(name: "Grok", urlString: "https://x.ai/")
    ]
}
