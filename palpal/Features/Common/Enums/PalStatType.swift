import SwiftUI

public enum PalStatType: String, Sendable, Equatable, Codable {
    case hp
    case defense
    case craftingSpeed
    case meleeAttack
    case shotAttack
    case price
    case stamina
    case support
    case runningSpeed
    case rideSprintSpeed
    case slowWalkSpeed
}

extension PalStatType {
    var getStringValue: String {
        switch self {
        case .hp:
            "HP"
        case .defense:
            "Defense"
        case .craftingSpeed:
            "Crafting Speed"
        case .meleeAttack:
            "Melee Attack"
        case .shotAttack:
            "Shot Attack"
        case .price:
            "Price"
        case .stamina:
            "Stamina"
        case .support:
            "Support"
        case .runningSpeed:
            "Running Speed"
        case .rideSprintSpeed:
            "Ride Sprint Speed"
        case .slowWalkSpeed:
            "Slow Walk Speed"
        }
    }
}
