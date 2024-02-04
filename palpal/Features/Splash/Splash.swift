import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct Splash {
    @Dependency(\.firebaseClient) var firebaseClient
    @Dependency(\.mainQueue) var mainQueue
    
    @ObservableState
    struct State: Equatable {
        @Presents var route: Route.State?
        
        var cancellables: Set<AnyCancellable> = []
        
        init(route: Route.State? = nil) {
            self.route = route
        }
    }
    
    @Reducer
    struct Route {
        @ObservableState
        enum State: Equatable {
            case userAuth(UserAuth.State)
            case palList(PalList.State)
        }
        enum Action {
            case userAuth(UserAuth.Action)
            case palList(PalList.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.palList, action: \.palList) {
                PalList()
            }
            Scope(state: \.userAuth, action: \.userAuth) {
                UserAuth()
            }
        }
    }
    
    enum Action: ViewAction {
        case route(PresentationAction<Route.Action>)
        case authStatusListener
        case didReceiveAuthStatusResult(Bool)
        case view(View)
        
        enum View {
            case onAppear
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .authStatusListener:
                return .publisher() {
                    self.firebaseClient.isAuthorizedUser.receive(on: mainQueue).map {
                        .didReceiveAuthStatusResult($0)
                    }
                }
            case .didReceiveAuthStatusResult(let isUserAuthorized):
                if isUserAuthorized {
                    state.route = .palList(.init(searchQuery: "", pals: [], filteredPals: []))
                } else {
                    state.route = .userAuth(.init())
                }
                return .none
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    firebaseClient.fetchUserSession()
                    return .run { send in
                        await send(.authStatusListener)
                    }
                }
            case .route(_):
                return .none
            }
        }
        .ifLet(\.$route, action: \.route) {
            Route()
        }
    }
}
