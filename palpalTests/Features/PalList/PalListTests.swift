import XCTest
import ComposableArchitecture

@testable import palpal

@MainActor
final class PalListTests: XCTestCase {
    func testInitialValues() {
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init
        )
        
        XCTAssertNil(sut.state.route)
        XCTAssertEqual(sut.state.searchQuery, "")
        XCTAssertEqual(sut.state.pals, [])
        XCTAssertEqual(sut.state.filteredPals, [])
    }
    
    func testOnAppear() async {
        var didFetchPalData = false
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init,
            withDependencies: {
                $0.firebaseClient.fetchPalsData = {
                    didFetchPalData = true
                    return []
                }
            }
        )
        
        await sut.send(.view(.onAppear))
        await sut.receive(\.fetchPalsResponse)
        XCTAssertTrue(didFetchPalData)
    }
    
    func testDidTapDetailsButton() async {
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init
        )
        
        let expectedValue: PalModel = .mock
        await sut.send(.view(.didTapDetailsButton(expectedValue))) {
            $0.route = .palDetails(
                .init(
                    pal: expectedValue,
                    team: .init(
                        myTeam: []
                    )
                )
            )
        }
    }
    
    func testDidTapLogout() async {
        var didTapLogout = false
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init,
            withDependencies: {
                $0.firebaseClient.logout = {
                    didTapLogout = true
                }
            }
        )
        
        await sut.send(.view(.didTapLogout))
        XCTAssertTrue(didTapLogout)
    }
    
    func testDidFilterPals() async {
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init
        )
        
        await sut.send(.view(.onAppear))
        await sut.receive(\.fetchPalsResponse) {
            $0.pals = [.mock, .mock2]
            $0.filteredPals = [.mock, .mock2]
        }
        
        let searchQuery = "oxp"
        await sut.send(.searchQueryChanged(searchQuery)) {
            $0.searchQuery = searchQuery
            $0.pals = [.mock, .mock2]
            $0.filteredPals = [.mock]
        }
        
        let emptySearchQuery = ""
        await sut.send(.searchQueryChanged(emptySearchQuery)) {
            $0.searchQuery = emptySearchQuery
            $0.pals = [.mock, .mock2]
            $0.filteredPals = [.mock, .mock2]
        }
    }
    
    func testDidReceiveFetchPalsResult() async {
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init
        )
        
        await sut.send(.view(.onAppear))
        await sut.receive(\.fetchPalsResponse) {
            $0.pals = [.mock, .mock2]
            $0.filteredPals = [.mock, .mock2]
        }
    }
    
    func testDidChangeSearchQuery() async {
        let sut = TestStore(
            initialState: PalList.State(),
            reducer: PalList.init
        )
        
        let expectedValue = "test"
        await sut.send(.searchQueryChanged(expectedValue)) {
            $0.searchQuery = expectedValue
        }
    }
}

