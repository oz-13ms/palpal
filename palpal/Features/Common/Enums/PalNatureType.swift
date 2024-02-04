import SwiftUI

public enum PalNatureType: String, Sendable, Equatable, Codable {
    case grass
    case ground
    case electric
    case water
    case fire
    case ice
    case dragon
    case dark
    case neutral
}

extension Image {
    init(palNatureType: PalNatureType) {
        switch palNatureType {
        case .grass:
            self = Image("GrassIcon")
        case .ground:
            self = Image("GroundIcon")
        case .electric:
            self = Image("ElectricIcon")
        case .water:
            self = Image("WaterIcon")
        case .fire:
            self = Image("FireIcon")
        case .ice:
            self = Image("IceIcon")
        case .dragon:
            self = Image("DragonIcon")
        case .dark:
            self = Image("DarkIcon")
        case .neutral:
            self = Image("NeutralIcon")
        }
    }
}
