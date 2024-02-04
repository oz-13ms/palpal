import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Dependencies
import Combine
import FirebaseCore

enum FirebaseClientError: Error {
    case notAuthorized
    case firebaseNotInitialized
}

struct FirebaseClient {
    var configure: () -> Void
    var fetchUserSession: () -> Void
    var isAuthorizedUser: AnyPublisher<Bool, Never>
    var loginAnonymously: () async throws -> Void
    var logout: () async throws -> Void
    var fetchPalsData: () async throws -> [PalModel]
    var fetchTeamData: () async throws -> TeamModel
    var updateTeam: (TeamModel) throws -> Void
}

extension FirebaseClient: DependencyKey {
    static var liveValue: FirebaseClient {
        var firestore: Firestore?
        var auth: Auth?
        let userSubject = CurrentValueSubject<Bool, Never>(false)
        return Self(
            configure: {
                FirebaseApp.configure()
                firestore = Firestore.firestore()
                auth = Auth.auth()
            },
            fetchUserSession: {
                userSubject.send(auth?.currentUser != nil)
            },
            isAuthorizedUser: userSubject.eraseToAnyPublisher(),
            loginAnonymously: {
                guard let auth else { throw FirebaseClientError.firebaseNotInitialized }
                try await auth.signInAnonymously()
                userSubject.send(auth.currentUser != nil)
            },
            logout: {
                guard let auth else { throw FirebaseClientError.firebaseNotInitialized }
                try auth.signOut()
                userSubject.send(auth.currentUser != nil)
            },
            fetchPalsData: {
                guard let firestore else {throw FirebaseClientError.firebaseNotInitialized}
                let snapshot = try await firestore.collection(Constants.palsCollection).getDocuments()
                let pals: [PalModel] = try snapshot.documents.compactMap { document in
                    return try document.data(as: PalModel.self)
                }
                return pals
            },
            fetchTeamData: {
                guard let auth, let firestore else {throw FirebaseClientError.firebaseNotInitialized}
                guard let currentUser = auth.currentUser else {
                    throw FirebaseClientError.notAuthorized
                }
                let document = try await firestore.collection(Constants.userTeamsCollection).document(currentUser.uid).getDocument()
                return try document.data(as: TeamModel.self)
                
            },
            updateTeam: { teamData in
                guard let auth, let firestore else { throw FirebaseClientError.firebaseNotInitialized }
                guard let currentUser = auth.currentUser else {
                    throw FirebaseClientError.notAuthorized
                }
                try firestore.collection(Constants.userTeamsCollection).document(currentUser.uid).setData(from: teamData)
            }
        )
    }
    
    static var testValue: FirebaseClient {
        Self(
            configure: {},
            fetchUserSession: {},
            isAuthorizedUser: Empty().eraseToAnyPublisher(),
            loginAnonymously: {},
            logout: {},
            fetchPalsData: { [.mock, .mock2] },
            fetchTeamData: { TeamModel.init(myTeam: [.mock]) },
            updateTeam: { _ in }
        )
    }
}

extension FirebaseClient {
    enum Constants {
        static let userTeamsCollection: String = "userTeams"
        static let palsCollection: String = "pals"
    }
}

extension DependencyValues {
    var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}
