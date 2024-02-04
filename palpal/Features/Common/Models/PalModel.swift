import Foundation

public struct PalModel: Sendable, Codable, Equatable, Identifiable {
    public let avatarUrl: String
    public let id: Int
    public let name: String
    public let element: PalNatureType
    public let workSuitability: [WorkModel]
    public let possibleDrops: [DropModel]
    public let stats: [String: Int]
    public let description: String
    
    var readableStats: [PalStatType: Int] {
        var modifiedDictionary: [PalStatType: Int] = [:]
        for (key, value) in stats {
            guard let palStat = PalStatType(rawValue: key) else { continue }
            modifiedDictionary[palStat] = value
        }
        return modifiedDictionary
    }
    
    public init(
        avatarUrl: String,
        id: Int,
        name: String,
        nature: PalNatureType,
        workSuitability: [WorkModel],
        possibleDrops: [DropModel],
        stats: [String: Int],
        description: String
    ) {
        self.avatarUrl = avatarUrl
        self.id = id
        self.name = name
        self.element = nature
        self.workSuitability = workSuitability
        self.possibleDrops = possibleDrops
        self.stats = stats
        self.description = description
    }
    
    public static func == (lhs: PalModel, rhs: PalModel) -> Bool {
        return lhs.avatarUrl == rhs.avatarUrl &&
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.element == rhs.element &&
        lhs.workSuitability == rhs.workSuitability &&
        lhs.possibleDrops == rhs.possibleDrops &&
        lhs.stats == rhs.stats &&
        lhs.description == rhs.description
    }
}

extension PalModel {
    public static var mock: PalModel {
        PalModel(
            avatarUrl: "https://static.wikia.nocookie.net/palworld/images/d/dd/Foxparks.png/revision/latest?cb=20240123163335",
            id: 5,
            name: "Foxparks",
            nature: .fire,
            workSuitability: [
                .init(
                    skill: .kindling,
                    level: 1
                )
            ],
            possibleDrops: [
                .init(name: "Fire Organ", minAmount: 1, maxAmount: 2, dropRate: 100),
                .init(name: "Leather", minAmount: 1, maxAmount: 1, dropRate: 100)
            ],
            stats: [
                "craftingSpeed": 100,
                "defense": 60,
                "hp": 60,
                "meleeAttack": 80,
                "price": 1120,
                "rideSprintSpeed": 400,
                "runningSpeed": 300,
                "shotAttack": 80,
                "slowWalkSpeed": 70,
                "stamina": 100,
                "support": 100
            ],
            description: "It is unskilled at controlling fire from the moment it is born and tends to choke on the flames it breathes unintentionally. Kitsunebi sneezes are one of the leading causes of forest fires."
        )
    }
    
    
    public static var mock2: PalModel {
        PalModel(
          avatarUrl: "https://static.wikia.nocookie.net/palworld/images/6/6c/Fuack.png/revision/latest?cb=20240123163258",
          id: 6,
          name: "Fuack",
          nature: .water,
          workSuitability: [
            .init(
              skill: .watering,
              level: 1
            ),
            .init(
              skill: .handiwork,
              level: 1
            ),
            .init(
              skill: .transporting,
              level: 1
            )
          ],
          possibleDrops: [
            .init(
              name: "Leather",
              minAmount: 1,
              maxAmount: 1,
              dropRate: 100
            ),
            .init(
              name: "Pal Fluids",
              minAmount: 1,
              maxAmount: 1,
              dropRate: 100
            )
          ],
          stats: [
            "craftingSpeed": 100,
            "defense": 60,
            "hp": 60,
            "meleeAttack": 80,
            "price": 1120,
            "rideSprintSpeed": 400,
            "runningSpeed": 300,
            "shotAttack": 80,
            "slowWalkSpeed": 70,
            "stamina": 100,
            "support": 100
          ],
          description: "Using its own body water, this Pal can create waves anywhere. It body surfs when in a hurry, but the resulting speed often ends in a fatal collision."
        )
    }
}
