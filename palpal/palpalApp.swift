import SwiftUI
import Dependencies

final class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: - Propreties

    @Dependency(\.firebaseClient) private var firebaseClient

    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/testing/#Testing-gotchas
        if !_XCTIsTesting {
            firebaseClient.configure()
        }
        return true
    }
}

@main
struct palpalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                SplashView(store: .init(initialState: Splash.State(), reducer: { Splash() }))
            }
        }
    }
}
