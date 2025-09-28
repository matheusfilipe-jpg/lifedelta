import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if healthManager.isOnboarded {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("LifeScore")
                        }
                        .tag(0)
                    
                    HabitSimulatorView()
                        .tabItem {
                            Image(systemName: "slider.horizontal.3")
                            Text("Simulator")
                        }
                        .tag(1)
                    
                    ARScannerView()
                        .tabItem {
                            Image(systemName: "camera.viewfinder")
                            Text("Scan")
                        }
                        .tag(2)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                        .tag(3)
                }
                .accentColor(.green)
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            checkOnboardingStatus()
        }
    }
    
    private func checkOnboardingStatus() {
        if !healthManager.isOnboarded {
            showingOnboarding = true
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
        .environmentObject(LifeDeltaModel())
        .environmentObject(SubscriptionManager())
}
