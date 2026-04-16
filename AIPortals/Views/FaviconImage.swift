internal import SwiftUI

struct FaviconImage: View {
    let urlString: String
    @State private var image: NSImage?

    private var faviconURL: URL? {
        guard let host = URL(string: urlString)?.host else { return nil }
        return URL(string: "https://www.google.com/s2/favicons?domain=\(host)&sz=64")
    }

    var body: some View {
        Group {
            if let image {
                Image(nsImage: image).resizable().scaledToFit()
            } else {
                Image(systemName: "globe").resizable().scaledToFit()
            }
        }
        .frame(width: 16, height: 16)
        .task(id: urlString) {
            guard let url = faviconURL else { return }
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let img = NSImage(data: data) else { return }
            image = img
        }
    }
}
