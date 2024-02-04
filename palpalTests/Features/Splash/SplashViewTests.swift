import XCTest
import SnapshotTesting

@testable import palpal

final class SplashViewTests: XCTestCase {
    func testLoadingView() {
        let splashView = SplashView(store: .init(initialState: Splash.State(), reducer: Splash.init))

        assertSnapshot(matching: splashView, as: .image(layout: .device(config: .iPhone13)))
    }

    func testAuthView() {
        let splashView = SplashView(store: .init(initialState: Splash.State(route: .userAuth(.init())), reducer: Splash.init))

        assertSnapshot(matching: splashView, as: .image(layout: .device(config: .iPhone13)))
    }

    func testPalsView() {
        let splashView = SplashView(store: .init(initialState: Splash.State(route: .palList(.init())), reducer: Splash.init))

        assertSnapshot(matching: splashView, as: .image(layout: .device(config: .iPhone13)))
    }
}
