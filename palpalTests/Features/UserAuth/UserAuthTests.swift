import XCTest
import ComposableArchitecture

@testable import palpal

final class UserAuthTests: XCTestCase {
    @MainActor
    func testDidTapStartButton() async {
        var didTapStart = false
        let sut = TestStore(
            initialState: UserAuth.State(),
            reducer: UserAuth.init,
            withDependencies: {
                $0.firebaseClient.loginAnonymously = {
                    didTapStart = true
                }
            }
        )
        
        await sut.send(.view(.startButtonTapped))
        XCTAssertTrue(didTapStart)
    }
}
