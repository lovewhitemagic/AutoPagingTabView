import SwiftUI
import Combine

public struct AutoPagingTabView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {

    private let data: Data
    private let interval: TimeInterval
    private let cornerRadius: CGFloat
    private let outerPadding: CGFloat
    private let shadowRadius: CGFloat
    private let content: (Data.Element) -> Content

    @State private var currentIndex: Int = 0
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>

    public init(
        data: Data,
        interval: TimeInterval = 3,
        cornerRadius: CGFloat = 12,
        outerPadding: CGFloat = 16,
        shadowRadius: CGFloat = 4,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.interval = interval
        self.cornerRadius = cornerRadius
        self.outerPadding = outerPadding
        self.shadowRadius = shadowRadius
        self.content = content
        self._timer = State(initialValue: Timer.publish(every: interval, on: .main, in: .common).autoconnect())
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(data.enumerated()), id: \.1.id) { index, item in
                content(item)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(cornerRadius)
                    .shadow(radius: shadowRadius)
                    .padding(.horizontal, outerPadding)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % data.count
            }
        }
    }
}
