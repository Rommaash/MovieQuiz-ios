import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs:GameRecord, rhs:GameRecord) -> Bool {
        let lhsAccuracy: Double = Double(lhs.correct) / Double(lhs.total)
        let rhsAccuracy: Double = Double(rhs.correct) / Double(rhs.total)
        return lhsAccuracy < rhsAccuracy
    }
}
