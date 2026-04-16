internal import SwiftUI

struct RootView: View {
	@State private var store = AISitesStore()

	var body: some View {
		NavigationSplitView {
			SidebarView()
				.environment(store)
				.navigationTitle("AI 工具")
		} detail: {
			if let selected = store.selected {
				WebContainerView(site: selected)
					.navigationTitle(selected.name)
			} else {
				ContentUnavailableView("未选择站点", systemImage: "globe", description: Text("从左侧选择或添加一个站点"))
			}
		}
	}
}

