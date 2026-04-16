//
//  RootView.swift
//  mmaipad
//
//  Created by loveliness on 2026/4/16.
//


import SwiftUI

struct RootView: View {
    @StateObject private var store = AISitesStore()

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(store)
                .navigationTitle("AI 工具")