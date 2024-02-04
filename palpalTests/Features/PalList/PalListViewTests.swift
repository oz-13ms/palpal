import XCTest
import SnapshotTesting

@testable import palpal

final class PalListViewTests: XCTestCase {
    func testPalListView() {
        let palListView = PalListView(
            store: .init(
                initialState: PalList.State(
                    searchQuery: "",
                    pals: [.mock, .mock2]
                ),
                reducer: PalList.init
            )
        )
        assertSnapshot(matching: palListView, as: .image(layout: .device(config: .iPhone13)))
    }
    
    

    func testPalDetailsView() {
        let palListView = PalListView(
            store: .init(
                initialState: PalList.State(
                    route: .palDetails(
                        .init(
                            pal: .mock,
                            team: .init(myTeam: [])
                        )
                    ),
                    searchQuery: "",
                    pals: [.mock, .mock2]
                ),
                reducer: PalList.init
            )
        )
        assertSnapshot(matching: palListView, as: .image(layout: .device(config: .iPhone13)))
    }
}
