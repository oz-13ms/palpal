import XCTest
import ComposableArchitecture
import Combine

@testable import palpal

final class SplashTests: XCTestCase {
    func testInitialValues() {
        let sut = TestStore(
            initialState: Splash.State(),
            reducer: Splash.init
        )

        XCTAssertNil(sut.state.route)
    }

    @MainActor
    func testOnAppear() async {
        var didFetchUserSession: Bool = false
        let sut = TestStore(
            initialState: Splash.State(),
            reducer: Splash.init,
            withDependencies: {
                $0.firebaseClient.fetchUserSession = {
                    didFetchUserSession = true
                }
                $0.mainQueue = .immediate
            }
        )

        await sut.send(.view(.onAppear))
        XCTAssertTrue(didFetchUserSession)
        await sut.receive(\.authStatusListener)
    }

    @MainActor
    func testDidReceiveAuthStatusResult() async {
        let userAuthorizationSubject: PassthroughSubject<Bool, Never> = .init()
        let sut = TestStore(
            initialState: Splash.State(),
            reducer: Splash.init,
            withDependencies: {
                $0.firebaseClient.isAuthorizedUser = userAuthorizationSubject.eraseToAnyPublisher()
                $0.mainQueue = .immediate
            }
        )
        await sut.send(.view(.onAppear))
        await sut.receive(\.authStatusListener)
        XCTAssertNil(sut.state.route)
        userAuthorizationSubject.send(true)
        await sut.receive(\.didReceiveAuthStatusResult) {
            $0.route = .palList(.init())
        }
        userAuthorizationSubject.send(false)
        await sut.receive(\.didReceiveAuthStatusResult) {
            $0.route = .userAuth(.init())
        }
        userAuthorizationSubject.send(completion: .finished)
    }
}
