import SwiftUI

struct RootView: View {
    @StateObject private var store = AISitesStore()

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(store)
                .navigationTitle("AI 工具")