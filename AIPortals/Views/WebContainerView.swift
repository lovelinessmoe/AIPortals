internal import SwiftUI
import WebKit

final class WebViewCache {
    static let shared = WebViewCache()
    private var cache: [UUID: WKWebView] = [:]

    func webView(for site: AISite) -> WKWebView {
        if let existing = cache[site.id] { return existing }
        let config = WKWebViewConfiguration()
        // 每个站点用固定 UUID 作为持久化存储标识，跨版本更新不丢失
        config.websiteDataStore = WKWebsiteDataStore(forIdentifier: site.id)
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.autoresizingMask = [.width, .height]
        wv.allowsBackForwardNavigationGestures = true
        if let url = URL(string: site.urlString) {
            wv.load(URLRequest(url: url))
        }
        cache[site.id] = wv
        return wv
    }
}

struct WebContainerView: View {
    let site: AISite
    @State private var isLoading = true

    var body: some View {
        ZStack {
            _WebView(site: site, isLoading: $isLoading)
            if isLoading {
                ProgressView("加载中…")
                    .progressViewStyle(.circular)
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private struct _WebView: NSViewRepresentable {
    let site: AISite
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator { Coordinator(isLoading: $isLoading) }

    func makeNSView(context: Context) -> NSView {
        let container = NSView()
        let webView = WebViewCache.shared.webView(for: site)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.frame = container.bounds
        container.addSubview(webView)
        isLoading = webView.isLoading
        return container
    }

    func updateNSView(_ container: NSView, context: Context) {
        let webView = WebViewCache.shared.webView(for: site)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        if webView.superview !== container {
            container.subviews.forEach { $0.removeFromSuperview() }
            webView.frame = container.bounds
            container.addSubview(webView)
        } else {
            webView.frame = container.bounds
        }
        isLoading = webView.isLoading
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        @Binding var isLoading: Bool
        init(isLoading: Binding<Bool>) { _isLoading = isLoading }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) { isLoading = true }
        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) { isLoading = false }
        func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) { isLoading = false }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) { isLoading = false }

        // 处理文件上传
        func webView(_ webView: WKWebView,
                     runOpenPanelWith parameters: WKOpenPanelParameters,
                     initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping ([URL]?) -> Void) {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = parameters.allowsMultipleSelection
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.begin { response in
                completionHandler(response == .OK ? panel.urls : nil)
            }
        }
    }
}

