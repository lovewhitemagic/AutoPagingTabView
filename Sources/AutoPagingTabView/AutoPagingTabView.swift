import SwiftUI
import Combine

public struct AutoPagingTabView: View {
    let titles: [String]
    let colors: [Color]
    let interval: TimeInterval
    let cornerRadius: CGFloat
    let outerPadding: CGFloat
    let shadowRadius: CGFloat

    private var count: Int { min(titles.count, colors.count) }
    private var loopedCount: Int { count + 2 }

    @State private var currentIndex: Int = 1
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>

    public init(
        titles: [String],
        colors: [Color],
        interval: TimeInterval = 3,
        cornerRadius: CGFloat = 12,
        outerPadding: CGFloat = 16,
        shadowRadius: CGFloat = 4
    ) {
        self.titles = titles
        self.colors = colors
        self.interval = interval
        self.cornerRadius = cornerRadius
        self.outerPadding = outerPadding
        self.shadowRadius = shadowRadius
        self._timer = State(initialValue: Timer.publish(every: interval, on: .main, in: .common).autoconnect())
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            // 前置复制页（最后一页）
            cardView(index: count - 1)
                .tag(0)

            ForEach(0..<count, id: \.self) { index in
                cardView(index: index)
                    .tag(index + 1)
            }

            // 后置复制页（第一页）
            cardView(index: 0)
                .tag(loopedCount - 1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex += 1
            }
        }
        .onChange(of: currentIndex) { newIndex in
            if newIndex == loopedCount - 1 {
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

    private func cardView(index: Int) -> some View {
        ZStack {
            colors[index]
            Text(titles[index])
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .frame(height: 200)
        .cornerRadius(cornerRadius)
        .shadow(radius: shadowRadius)
        .padding(.horizontal, outerPadding)
    }
}
