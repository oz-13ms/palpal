import Foundation

public struct DropModel: Sendable, Codable, Equatable {
    public let name: String
    public let minAmount: Int
    public let maxAmount: Int
    public let dropRate: Int

    public init(name: String, minAmount: Int, maxAmount: Int, dropRate: Int) {
        self.name = name
        self.minAmount = minAmount
        self.maxAmount = maxAmount
        self.dropRate = dropRate
    }
}
