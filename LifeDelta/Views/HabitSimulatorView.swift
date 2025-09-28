import SwiftUI

struct HabitSimulatorView: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var habitChanges: [String: Double] = [:]
    @State private var showingPaywall = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if subscriptionManager.isProUser {
                        simulatorContent
                    } else {
                        paywallContent
                    }
                }
                .padding()
            }
            .navigationTitle("Habit Simulator")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var simulatorContent: some View {
        VStack(spacing: 20) {
            // Current Life Expectancy
            CurrentLifeExpectancyCard()
            
            // Habit Controls
            VStack(spacing: 15) {
                HabitSlider(
                    title: "Smoking",
                    icon: "smoke.fill",
                    value: $habitChanges["smoking"],
                    range: 0...1,
                    step: 1,
                    unit: "packs/day",
                    color: .red
                )
                
                HabitSlider(
                    title: "Exercise",
                    icon: "figure.run",
                    value: $habitChanges["exercise"],
                    range: 0...300,
                    step: 15,
                    unit: "min/week",
                    color: .green
                )
                
                HabitSlider(
                    title: "Sleep",
                    icon: "moon.fill",
                    value: $habitChanges["sleep"],
                    range: 5...10,
                    step: 0.5,
                    unit: "hours/night",
                    color: .blue
                )
                
                HabitSlider(
                    title: "Weight",
                    icon: "scalemass.fill",
                    value: $habitChanges["weight"],
                    range: -20...20,
                    step: 1,
                    unit: "kg change",
                    color: .orange
                )
                
                HabitSlider(
                    title: "Alcohol",
                    icon: "wineglass.fill",
                    value: $habitChanges["alcohol"],
                    range: 0...14,
                    step: 1,
                    unit: "drinks/week",
                    color: .purple
                )
            }
            
            // Delta Results
            DeltaResultsCard()
            
            // Reset Button
            Button("Reset All") {
                habitChanges.removeAll()
            }
            .foregroundColor(.secondary)
        }
    }
    
    private var paywallContent: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Unlock Habit Simulator")
                .font(.title)
                .fontWeight(.bold)
            
            Text("See how your habits impact your life expectancy with our advanced simulator")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                FeatureRow(icon: "slider.horizontal.3", title: "Real-time habit simulation", description: "Adjust habits and see instant life expectancy changes")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Detailed impact analysis", description: "Understand which habits have the biggest impact")
                FeatureRow(icon: "arrow.clockwise", title: "What-if scenarios", description: "Test different lifestyle changes safely")
            }
            
            Button("Upgrade to Pro") {
                showingPaywall = true
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(15)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
}

struct CurrentLifeExpectancyCard: View {
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Current Life Expectancy")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                VStack {
                    Text("\(lifeDeltaModel.lifeScore.remainingYears, specifier: "%.1f")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                    Text("years")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("\(Int(lifeDeltaModel.lifeScore.remainingYears * 365))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                    Text("days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct HabitSlider: View {
    let title: String
    let icon: String
    @Binding var value: Double?
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if let value = value {
                    Text("\(value, specifier: "%.1f") \(unit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Slider(
                value: Binding(
                    get: { value ?? range.lowerBound },
                    set: { value = $0 }
                ),
                in: range,
                step: step
            )
            .accentColor(color)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct DeltaResultsCard: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    @State private var currentDelta = LifeDelta(daysGained: 0)
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                Text("Impact Analysis")
                    .font(.headline)
                Spacer()
            }
            
            if currentDelta.daysGained != 0 {
                VStack(spacing: 10) {
                    HStack {
                        Text("Total Impact:")
                            .font(.subheadline)
                        Spacer()
                        Text("\(currentDelta.daysGained >= 0 ? "+" : "")\(Int(currentDelta.daysGained)) days")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(currentDelta.daysGained >= 0 ? .green : .red)
                    }
                    
                    if !currentDelta.topRiskFactors.isEmpty {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(currentDelta.topRiskFactors) { factor in
                                HStack {
                                    Image(systemName: factor.isPositive ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                        .foregroundColor(factor.isPositive ? .green : .red)
                                        .frame(width: 16)
                                    
                                    Text(factor.name)
                                        .font(.caption)
                                    
                                    Spacer()
                                    
                                    Text("\(factor.impact >= 0 ? "+" : "")\(Int(factor.impact))")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(factor.isPositive ? .green : .red)
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Adjust habits above to see their impact")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .onChange(of: lifeDeltaModel.currentDelta) { _, newValue in
            currentDelta = newValue
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    HabitSimulatorView()
        .environmentObject(HealthManager())
        .environmentObject(LifeDeltaModel())
        .environmentObject(SubscriptionManager())
}
