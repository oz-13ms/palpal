import ComposableArchitecture

@Reducer
struct UserAuth {
    @Dependency(\.firebaseClient) var firebaseClient
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action: ViewAction {
        case view(View)
        
        enum View {
            case startButtonTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .startButtonTapped:
                    return .run { _ in
                        _ = try await firebaseClient.loginAnonymously()
                    }
                }
            }
        }
    }
}
