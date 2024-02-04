import SwiftUI
import ComposableArchitecture

@ViewAction(for: Splash.self)
struct SplashView: View {
    @Bindable var store: StoreOf<Splash>
    
    var body: some View {
        ZStack {
            Color.primaryL
            switch store.route {
            case .userAuth:
                if let authStore = store.scope(state: \.route?.userAuth, action: \.route.userAuth) {
                    UserAuthView(store: authStore)
                }
            case .palList:
                if let palListStore = store.scope(state: \.route?.palList, action: \.route.palList) {
                    PalListView(store: palListStore)
                }
            default:
                Color.primaryL
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear{
            send(.onAppear)
        }
    }
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(store: .init(
            initialState: Splash.State(),
            reducer: {
                Splash()
            })
        )
    }
}
#endif
