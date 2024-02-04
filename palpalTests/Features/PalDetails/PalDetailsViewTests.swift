import XCTest
import SnapshotTesting

@testable import palpal

final class PalDetailsViewTests: XCTestCase {
    func testPalDetailsView() {
        let palDetailsView = PalDetailsView(store: .init(initialState: PalDetails.State(pal: .mock, team: .init(myTeam: [.mock, .mock])), reducer: PalDetails.init))

        assertSnapshot( matching: palDetailsView, as: .image(layout: .device(config: .iPhone13)))
    }
}
