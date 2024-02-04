import ComposableArchitecture
import SwiftUI

@Reducer
struct PalList {
    @Dependency(\.firebaseClient) var firebaseClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var route: Route.State?
        
        var searchQuery: String
        var pals: [PalModel]
        var filteredPals: [PalModel]
        
        init(
            route: Route.State? = nil,
            searchQuery: String = "",
            pals: [PalModel] = [],
            filteredPals: [PalModel] = []
        ) {
            self.route = route
            self.searchQuery = searchQuery
            self.pals = pals
            self.filteredPals = filteredPals
        }
    }
    
    @Reducer
    struct Route {
        @ObservableState
        enum State: Equatable {
            case palDetails(PalDetails.State)
        }
        enum Action: Sendable {
            case palDetails(PalDetails.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.palDetails, action: \.palDetails) {
                PalDetails()
            }
        }
    }
    
    enum Action: ViewAction, Sendable {
        case route(PresentationAction<Route.Action>)
        case fetchPalsResponse(Result<[PalModel], Error>)
        case searchQueryChanged(String)
        case view(View)
        
        enum View {
            case onAppear
            case didTapDetailsButton(PalModel)
            case didTapLogout
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .didTapLogout:
                    return .run { _ in
                        _ = try await firebaseClient.logout()
                    }
                case .didTapDetailsButton(let pal):
                    state.route = .palDetails(PalDetails.State(pal: pal, team: TeamModel(myTeam: [])))
                    return .none
                case .onAppear:
                    return .run { send in
                        await send(
                            .fetchPalsResponse(
                                Result{
                                    try await firebaseClient.fetchPalsData()
                                }
                            )
                        )
                    }
                }
                
            case .searchQueryChanged(let searchQuery):
                state.searchQuery = searchQuery
                guard !state.searchQuery.isEmpty else {
                    state.filteredPals = state.pals
                    return .none
                }
                state.filteredPals = state.pals.filter({ pal in
                    pal.name.lowercased().contains(state.searchQuery.lowercased())
                })
                return .none
            case .fetchPalsResponse(.success(let fetchedPals)):
                state.pals = fetchedPals
                state.filteredPals = state.pals
                return .none
            case .fetchPalsResponse(.failure(let error)):
                print(error)
                return .none
            case .route(_):
                return .none
            }
        }
        .ifLet(\.$route, action: \.route) {
            Route()
        }
    }
}
