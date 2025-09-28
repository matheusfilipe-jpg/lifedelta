import Foundation
import CoreML
import Combine

class LifeDeltaModel: ObservableObject {
    @Published var lifeScore = LifeScore(remainingYears: 50.0, confidenceRange: (45.0, 55.0))
    @Published var currentDelta = LifeDelta(daysGained: 0)
    @Published var isCalculating = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initialize with default values
        calculateLifeScore()
    }
    
    func calculateLifeScore() {
        isCalculating = true
        
        // Simulate ML model inference delay
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let result = self?.performSurvivalAnalysis() ?? LifeScore(remainingYears: 50.0)
            
            DispatchQueue.main.async {
                self?.lifeScore = result
                self?.isCalculating = false
            }
        }
    }
    
    func calculateHabitDelta(healthData: HealthData, habitChanges: [String: Double]) -> LifeDelta {
        // Simulate habit impact calculation
        var totalDaysGained = 0.0
        var riskFactors: [RiskFactor] = []
        
        // Smoking impact
        if let smokingChange = habitChanges["smoking"] {
            let smokingImpact = smokingChange * -365 // -1 year per smoking status
            totalDaysGained += smokingImpact
            riskFactors.append(RiskFactor(
                name: "Smoking",
                impact: smokingImpact,
                description: smokingChange > 0 ? "Quitting smoking adds significant years" : "Smoking reduces life expectancy"
            ))
        }
        
        // Exercise impact
        if let exerciseChange = habitChanges["exercise"] {
            let exerciseImpact = exerciseChange * 0.5 // 0.5 days per minute of exercise
            totalDaysGained += exerciseImpact
            riskFactors.append(RiskFactor(
                name: "Exercise",
                impact: exerciseImpact,
                description: "Regular exercise improves cardiovascular health",
                isPositive: true
            ))
        }
        
        // Sleep impact
        if let sleepChange = habitChanges["sleep"] {
            let sleepImpact = sleepChange * 30 // 30 days per hour of sleep
            totalDaysGained += sleepImpact
            riskFactors.append(RiskFactor(
                name: "Sleep",
                impact: sleepImpact,
                description: "Adequate sleep is crucial for longevity",
                isPositive: true
            ))
        }
        
        // Weight impact
        if let weightChange = habitChanges["weight"] {
            let weightImpact = weightChange * -10 // -10 days per kg
            totalDaysGained += weightImpact
            riskFactors.append(RiskFactor(
                name: "Weight",
                impact: weightImpact,
                description: "Maintaining healthy weight reduces disease risk"
            ))
        }
        
        let confidenceInterval = (totalDaysGained - 30, totalDaysGained + 30)
        
        return LifeDelta(
            daysGained: totalDaysGained,
            confidenceInterval: confidenceInterval,
            topRiskFactors: riskFactors.sorted { abs($0.impact) > abs($1.impact) }.prefix(3).map { $0 }
        )
    }
    
    private func performSurvivalAnalysis() -> LifeScore {
        // Simplified survival analysis based on actuarial tables
        // In a real implementation, this would use a trained Core ML model
        
        let baseLifeExpectancy = 80.0 // Base life expectancy
        let currentAge = 30.0 // This would come from health data
        
        // Calculate remaining years with some variance
        let remainingYears = baseLifeExpectancy - currentAge
        let confidenceRange = (remainingYears - 5, remainingYears + 5)
        let weeklyDelta = Double.random(in: -0.1...0.1) // Simulate weekly changes
        
        return LifeScore(
            remainingYears: remainingYears,
            confidenceRange: confidenceRange,
            weeklyDelta: weeklyDelta
        )
    }
    
    func updateWithHealthData(_ healthData: HealthData) {
        // Update model with new health data
        calculateLifeScore()
    }
}
