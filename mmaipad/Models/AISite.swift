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
    var systemSymbolName: String

    init(id: UUID = UUID(), name: String, urlString: String, systemSymbolName: String) {
        self.id = id
        self.name = name
        self.urlString = urlString
        self.systemSymbolName = systemSymbolName
    }
}

extension AISite {
    static let builtIns: [AISite] = [
        AISite(name: "Google AI Studio", urlString: "https://aistudio.google.com/", systemSymbolName: "globe"),
        AISite(name: "豆包", urlString: "https://www.doubao.com/", systemSymbolName: "leaf"),
        AISite(name: "DeepSeek", urlString: "https://chat.deepseek.com/", systemSymbolName: "brain"),
        AISite(name: "Monica", urlString: "https://monica.im/", systemSymbolName: "person.crop.circle"),
        AISite(name: "GPT", urlString: "https://chat.openai.com/", systemSymbolName: "bubble.left.and.bubble.right"),
        AISite(name: "Grok", urlString: "https://x.ai/", systemSymbolName: "sparkles")
    ]
}
