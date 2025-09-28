import SwiftUI

@main
struct LifeDeltaApp: App {
    @StateObject private var healthManager = HealthManager()
    @StateObject private var lifeDeltaModel = LifeDeltaModel()
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .environmentObject(lifeDeltaModel)
                .environmentObject(subscriptionManager)
                .preferredColorScheme(.dark)
        }
    }
}
