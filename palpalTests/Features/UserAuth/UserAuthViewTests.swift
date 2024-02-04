import XCTest
import SnapshotTesting

@testable import palpal

final class UserAuthViewTests: XCTestCase {
    func testAuthView() {
        let userAuthView = UserAuthView(store: .init(initialState: UserAuth.State(), reducer: UserAuth.init))

        assertSnapshot(matching: userAuthView, as: .image(layout: .device(config: .iPhone13)))
    }
}
