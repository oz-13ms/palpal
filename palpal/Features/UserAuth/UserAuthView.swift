import SwiftUI
import ComposableArchitecture

@ViewAction(for: UserAuth.self)
struct UserAuthView: View {
    @Bindable var store: StoreOf<UserAuth>
    
    var body: some View {
        ZStack {
            Button(action: { send(.startButtonTapped) }) {
                Text("Let's start")
            }
        }
    }
}

#if DEBUG
struct UserAuthView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthView(store: .init(
            initialState: UserAuth.State(),
            reducer: {
                UserAuth()
            })
        )
    }
}
#endif
