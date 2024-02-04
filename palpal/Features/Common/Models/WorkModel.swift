import Foundation

public struct WorkModel: Sendable, Codable, Equatable {
    public let skill: WorkSkillType
    public let level: Int

    public init(skill: WorkSkillType, level: Int) {
        self.skill = skill
        self.level = level
    }
}
