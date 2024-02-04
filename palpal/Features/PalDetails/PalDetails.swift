import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
struct PalDetails {
    @Dependency(\.firebaseClient) var firebaseClient
    
    @ObservableState
    struct State: Equatable {
        var pal: PalModel
        var team: TeamModel
        
        enum PalSpace {
            case pal(PalModel)
            case empty
        }
        
        var palDisplayData: [[PalSpace]] {
            let mirrorTeam = team.myTeam.map(PalSpace.pal)
            let additionalSpace = max(0, 5 - mirrorTeam.count)
            let palDisplayArray: [PalSpace] =  mirrorTeam + Array(repeating: .empty, count: additionalSpace)
            return stride(from: 0, to: palDisplayArray.count, by: 3).map { startIndex in
                let endIndex = startIndex + 3 > palDisplayArray.count ? palDisplayArray.count : startIndex + 3
                return Array(palDisplayArray[startIndex..<endIndex])
            }
        }
    }
    
    
    enum Action: ViewAction, Sendable {
        case fetchTeamResponse(Result<TeamModel, Error>)
        case view(View)
        
        enum View {
            case didTapPalCircle(PalModel, Int, Int)
            case didLongpressPalCircle(Int, Int)
            case onAppear
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return .run { send in
                        await send(
                            .fetchTeamResponse(
                                Result{
                                    try await firebaseClient.fetchTeamData()
                                }
                            )
                        )
                    }
                case .didLongpressPalCircle(let row, let index):
                    let singleDimIndex = row * 3 + index
                    if state.team.myTeam.indices.contains(singleDimIndex) {
                        state.team.myTeam.remove(at: singleDimIndex)
                    }
                    let newTeam = state.team
                    return .run { _ in
                            try firebaseClient.updateTeam(newTeam)
                    }
                case .didTapPalCircle(let pal, let row, let index):
                    let singleDimIndex = row * 3 + index
                    state.team.myTeam.indices.contains(singleDimIndex) ? state.team.myTeam[singleDimIndex] = pal : state.team.myTeam.append(pal)
                    let newTeam = state.team
                    return .run { _ in
                            try firebaseClient.updateTeam(newTeam)
                    }
                }
            case .fetchTeamResponse(.success(let newTeam)):
                state.team = newTeam
                return .none
            case .fetchTeamResponse(.failure(let error)):
                print(error)
                return .none
            }
        }
    }
}


