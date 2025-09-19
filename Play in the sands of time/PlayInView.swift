import Foundation
import SwiftUI

struct PlayInEntryScreen: View {
    @StateObject private var loader: PlayInWebLoader

    init(loader: PlayInWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            PlayInWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                PlayInProgressIndicator(value: percent)
            case .failure(let err):
                PlayInErrorIndicator(err: err)
            case .noConnection:
                PlayInOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct PlayInProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            PlayInLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct PlayInErrorIndicator: View {
    let err: String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct PlayInOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
