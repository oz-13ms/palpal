import SwiftUI

public enum WorkSkillType: String, Sendable, Equatable, Codable {
    case kindling
    case watering
    case planting
    case generatingElectricity
    case handiwork
    case gathering
    case lumbering
    case mining
    case medicineProduction
    case cooling
    case transporting
    case farming
}

extension WorkSkillType {
    var getStringValue: String {
        switch self {
        case .kindling:
            return "Kindling"
        case .watering:
            return "Watering"
        case .planting:
            return "Planting"
        case .generatingElectricity:
            return "Generating Electricity"
        case .handiwork:
            return "Handiwork"
        case .gathering:
            return "Gathering"
        case .lumbering:
            return "Lumbering"
        case .mining:
            return "Mining"
        case .medicineProduction:
            return "Medicine Production"
        case .cooling:
            return "Cooling"
        case .transporting:
            return "Transporting"
        case .farming:
            return "Farming"
        }
    }
}

extension Image {
    init(workSkillType: WorkSkillType) {
        switch workSkillType {
        case .kindling:
            self = Image("KindlingIcon")
        case .watering:
            self = Image("WateringIcon")
        case .planting:
            self = Image("PlantingIcon")
        case .generatingElectricity:
            self = Image("GeneratingElectricityIcon")
        case .handiwork:
            self = Image("HandiworkIcon")
        case .gathering:
            self = Image("GatheringIcon")
        case .lumbering:
            self = Image("LumberingIcon")
        case .mining:
            self = Image("MiningIcon")
        case .medicineProduction:
            self = Image("MedicineProductionIcon")
        case .cooling:
            self = Image("CoolingIcon")
        case .transporting:
            self = Image("TransportingIcon")
        case .farming:
            self = Image("FarmingIcon")
        }
    }
}
