import XCTest
import ComposableArchitecture

@testable import palpal

@MainActor
final class PalDetailsTests: XCTestCase {
    func testInitialValues() {
        let sut = TestStore(
            initialState: PalDetails.State(
                pal: .mock,
                team: .init(myTeam: [])
            ),
            reducer: PalDetails.init
        )
        
        XCTAssertEqual(sut.state.pal, .mock)
    }
    
    func testDidTapCircle() async {
        var didTapCircle = false
        let sut = TestStore(
            initialState: PalDetails.State(
                pal: .mock,
                team: .init(myTeam: [])
            ),
            reducer: PalDetails.init,
            withDependencies: {
                $0.firebaseClient.updateTeam = { _ in
                    didTapCircle = true
                }
            }
        )
        
        await sut.send(.view(.didTapPalCircle(.mock, 0, 0))) {
            $0.team = .init(myTeam: [.mock])
        }
        XCTAssertTrue(didTapCircle)
    }
    
    func testDidLongpressCircle() async {
        var didLongpressCircle = false
        let sut = TestStore(
            initialState: PalDetails.State(
                pal: .mock,
                team: .init(myTeam: [.mock])
            ),
            reducer: PalDetails.init,
            withDependencies: {
                $0.firebaseClient.updateTeam = { _ in
                    didLongpressCircle = true
                }
            }
        )
        
        await sut.send(.view(.didLongpressPalCircle(0, 0))) {
            $0.team = .init(myTeam: [])
        }
        XCTAssertTrue(didLongpressCircle)
    }
}
