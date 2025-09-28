import Foundation
import HealthKit
import Combine

class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var isOnboarded = false
    @Published var currentHealthData = HealthData()
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkHealthKitAvailability()
        loadOnboardingStatus()
    }
    
    private func checkHealthKitAvailability() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
    }
    
    func requestHealthKitPermissions() {
        let healthKitTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.fetchHealthData()
                }
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchHealthData() {
        isLoading = true
        
        let group = DispatchGroup()
        
        // Fetch steps
        group.enter()
        fetchSteps { [weak self] steps in
            self?.currentHealthData.steps = steps
            group.leave()
        }
        
        // Fetch resting heart rate
        group.enter()
        fetchRestingHeartRate { [weak self] rhr in
            self?.currentHealthData.restingHeartRate = rhr
            group.leave()
        }
        
        // Fetch sleep
        group.enter()
        fetchSleepHours { [weak self] sleep in
            self?.currentHealthData.sleepHours = sleep
            group.leave()
        }
        
        // Fetch VO2 Max
        group.enter()
        fetchVO2Max { [weak self] vo2 in
            self?.currentHealthData.vo2Max = vo2
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    private func fetchSteps(completion: @escaping (Int) -> Void) {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(8000) // Default fallback
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let steps = Int(sum.doubleValue(for: HKUnit.count()))
                completion(steps)
            } else {
                completion(8000) // Default fallback
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchRestingHeartRate(completion: @escaping (Double) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(70.0) // Default fallback
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.date(byAdding: .day, value: -7, to: calendar.startOfDay(for: now))!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 100, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            if let samples = samples as? [HKQuantitySample] {
                let heartRates = samples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
                let average = heartRates.reduce(0, +) / Double(heartRates.count)
                completion(average)
            } else {
                completion(70.0) // Default fallback
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchSleepHours(completion: @escaping (Double) -> Void) {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(7.5) // Default fallback
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.date(byAdding: .day, value: -7, to: calendar.startOfDay(for: now))!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 50, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            if let samples = samples as? [HKCategorySample] {
                var totalSleep: TimeInterval = 0
                for sample in samples {
                    if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                        totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }
                let averageHours = totalSleep / (7 * 3600) // Convert to hours per day
                completion(averageHours)
            } else {
                completion(7.5) // Default fallback
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchVO2Max(completion: @escaping (Double) -> Void) {
        guard let vo2Type = HKQuantityType.quantityType(forIdentifier: .vo2Max) else {
            completion(35.0) // Default fallback
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: now))!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: vo2Type, predicate: predicate, limit: 10, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            if let samples = samples as? [HKQuantitySample], let latest = samples.first {
                let vo2 = latest.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
                completion(vo2)
            } else {
                completion(35.0) // Default fallback
            }
        }
        
        healthStore.execute(query)
    }
    
    func updateUserProfile(age: Int, sex: HKBiologicalSex, weight: Double, height: Double) {
        currentHealthData.age = age
        currentHealthData.sex = sex
        currentHealthData.weight = weight
        currentHealthData.height = height
        saveOnboardingStatus()
    }
    
    private func saveOnboardingStatus() {
        UserDefaults.standard.set(true, forKey: "isOnboarded")
        isOnboarded = true
    }
    
    private func loadOnboardingStatus() {
        isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
    }
}
