import Foundation
import HealthKit

struct HealthData: Codable {
    var age: Int
    var sex: HKBiologicalSex
    var weight: Double // kg
    var height: Double // cm
    var steps: Int
    var restingHeartRate: Double // bpm
    var sleepHours: Double
    var vo2Max: Double // ml/kg/min
    var smokingStatus: Bool
    var alcoholConsumption: Double // drinks per week
    var exerciseMinutes: Double // per week
    
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    init() {
        self.age = 30
        self.sex = .notSet
        self.weight = 70.0
        self.height = 170.0
        self.steps = 8000
        self.restingHeartRate = 70.0
        self.sleepHours = 7.5
        self.vo2Max = 35.0
        self.smokingStatus = false
        self.alcoholConsumption = 0.0
        self.exerciseMinutes = 150.0
    }
}

struct LifeDelta: Codable {
    var daysGained: Double
    var confidenceInterval: (Double, Double)
    var topRiskFactors: [RiskFactor]
    var timestamp: Date
    
    init(daysGained: Double, confidenceInterval: (Double, Double) = (0, 0), topRiskFactors: [RiskFactor] = []) {
        self.daysGained = daysGained
        self.confidenceInterval = confidenceInterval
        self.topRiskFactors = topRiskFactors
        self.timestamp = Date()
    }
}

struct RiskFactor: Codable, Identifiable {
    let id = UUID()
    var name: String
    var impact: Double // days
    var description: String
    var isPositive: Bool
    
    init(name: String, impact: Double, description: String, isPositive: Bool = false) {
        self.name = name
        self.impact = impact
        self.description = description
        self.isPositive = isPositive
    }
}

struct LifeScore: Codable {
    var remainingYears: Double
    var confidenceRange: (Double, Double)
    var weeklyDelta: Double
    var lastUpdated: Date
    
    init(remainingYears: Double, confidenceRange: (Double, Double) = (0, 0), weeklyDelta: Double = 0) {
        self.remainingYears = remainingYears
        self.confidenceRange = confidenceRange
        self.weeklyDelta = weeklyDelta
        self.lastUpdated = Date()
    }
}
