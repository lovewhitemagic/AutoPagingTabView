import SwiftUI
import Combine

public struct AutoPagingTabView: View {
    private let interval: TimeInterval
    private let views: [AnyView]
    private let cardHeight: CGFloat
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let outerPadding: CGFloat

    @State private var currentIndex: Int = 1
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>

    public init(
        views: [AnyView],
        interval: TimeInterval = 3,
        cardHeight: CGFloat = 240,
        cornerRadius: CGFloat = 20,
        shadowRadius: CGFloat = 6,
        outerPadding: CGFloat = 24
    ) {
        self.interval = interval
        self.views = views
        self.cardHeight = cardHeight
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.outerPadding = outerPadding
        self._timer = State(initialValue: Timer.publish(every: interval, on: .main, in: .common).autoconnect())
    }

    public var body: some View {
        if views.count < 1 {
            EmptyView()
        } else {
            let count = views.count
            let loopedViews = [views.last!] + views + [views.first!]
            let total = count + 2

            TabView(selection: $currentIndex) {
                ForEach(0..<total, id: \.self) { i in
                    loopedViews[i]
                        .frame(maxWidth: .infinity)
                        .frame(height: cardHeight)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)
                        .shadow(radius: shadowRadius)
                        .padding(.horizontal, outerPadding)
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex += 1
                }
            }
            .onChange(of: currentIndex) { newIndex in
                if newIndex == total - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.none) {
                            currentIndex = 1
                        }
                    }
                }
            }
            .onAppear {
                currentIndex = 1
            }
        }
    }
}
