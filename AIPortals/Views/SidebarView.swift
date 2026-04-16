internal import SwiftUI

struct SidebarView: View {
    @State private var showingAdd = false
    @Environment(AISitesStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            List(selection: Binding(
                get: { store.selected?.id },
                set: { newID in
                    if let id = newID, let match = store.sites.first(where: { $0.id == id }) {
                        store.selected = match
                    }
                }
            )) {
                ForEach(store.sites) { site in
                    Label {
                        Text(site.name)
                    } icon: {
                        FaviconImage(urlString: site.urlString)
                    }
                    .tag(site.id)
                    .contextMenu {
                        Button("删除", role: .destructive) {
                            if let idx = store.sites.firstIndex(of: site) {
                                store.removeSites(at: IndexSet(integer: idx))
                            }
                        }
                    }
                }
                .onMove(perform: store.moveSites)
            }
            .listStyle(.sidebar)

            Button {
                showingAdd = true
            } label: {
                Label("添加站点", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .sheet(isPresented: $showingAdd) {
                AddSiteSheet()
                    .environment(store)
            }
        }
    }
}

struct AddSiteSheet: View {
    @Environment(AISitesStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var url: String = ""

    var body: some View {
        Form {
            TextField("名称", text: $name)
            TextField("URL", text: $url)
                .disableAutocorrection(true)
        }
        .padding()
        .frame(minWidth: 300)
        .navigationTitle("添加站点")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("添加") {
                    store.addSite(name: name, urlString: url)
                    dismiss()
                }
                .disabled(name.isEmpty || url.isEmpty)
            }
        }
    }
}
