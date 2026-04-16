//
//  SidebarView.swift
//  mmaipad
//
//  Created by loveliness on 2026/4/16.
//


import SwiftUI

struct SidebarView: View {
    @State private var showingAdd = false
    @Environment(AISitesStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            List(selection: Binding(get: { store.selected?.id }, set: { newID in
                if let id = newID, let match = store.sites.first(where: { $0.id == id }) {