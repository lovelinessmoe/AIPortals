//
//  AISitesStore.swift
//  mmaipad
//
//  Created by loveliness on 2026/4/16.
//


import Foundation
import Observation
internal import SwiftUI

@Observable
final class AISitesStore {
    private let storageKey = "custom.sites.v1"

    var sites: [AISite] = []
    var selected: AISite?

    init() {
        load()
        if sites.isEmpty {
            sites = AISite.builtIns
        }
        if selected == nil {
            selected = sites.first
        }
    }

    func addSite(name: String, urlString: String) {
        let site = AISite(name: name, urlString: urlString)
        sites.append(site)
        persist()
    }

    func removeSites(at offsets: IndexSet) {
        sites.remove(atOffsets: offsets)
        if let selected, !sites.contains(selected) {
            self.selected = sites.first
        }
        persist()
    }

    func moveSites(from source: IndexSet, to destination: Int) {
        sites.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    private func persist() {
        do {
            let data = try JSONEncoder().encode(sites)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Persist error: \(error)")
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            sites = try JSONDecoder().decode([AISite].self, from: data)
        } catch {
            print("Load error: \(error)")
        }
    }
}
