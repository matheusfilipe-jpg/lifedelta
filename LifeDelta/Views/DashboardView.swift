import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Life Countdown Card
                    LifeCountdownCard()
                    
                    // LifeScore Overview
                    LifeScoreCard()
                    
                    // Weekly Delta
                    WeeklyDeltaCard()
                    
                    // Top Risk Factors
                    RiskFactorsCard()
                    
                    // Health Data Summary
                    HealthDataCard()
                    
                    // Share Button
                    if subscriptionManager.isProUser {
                        ShareButton()
                    }
                }
                .padding()
            }
            .navigationTitle("LifeScore")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                healthManager.fetchHealthData()
                lifeDeltaModel.calculateLifeScore()
            }
        }
    }
}

struct LifeCountdownCard: View {
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.green)
                Text("Life Countdown")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 5) {
                Text("\(Int(lifeDeltaModel.lifeScore.remainingYears * 365))")
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                
                Text("days remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Confidence interval
            HStack {
                Text("Range:")
                Text("\(Int(lifeDeltaModel.lifeScore.confidenceRange.0 * 365)) - \(Int(lifeDeltaModel.lifeScore.confidenceRange.1 * 365)) days")
                    .fontWeight(.medium)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct LifeScoreCard: View {
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("LifeScore")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(lifeDeltaModel.lifeScore.remainingYears, specifier: "%.1f")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.red)
                    Text("years")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Last updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(lifeDeltaModel.lifeScore.lastUpdated, style: .relative)
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

struct WeeklyDeltaCard: View {
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "arrow.up.right")
                    .foregroundColor(lifeDeltaModel.lifeScore.weeklyDelta >= 0 ? .green : .red)
                Text("Weekly Change")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text(lifeDeltaModel.lifeScore.weeklyDelta >= 0 ? "+" : "")
                Text("\(lifeDeltaModel.lifeScore.weeklyDelta, specifier: "%.1f")")
                    .font(.system(size: 24, weight: .bold))
                Text("days")
                    .font(.caption)
            }
            .foregroundColor(lifeDeltaModel.lifeScore.weeklyDelta >= 0 ? .green : .red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct RiskFactorsCard: View {
    @EnvironmentObject var lifeDeltaModel: LifeDeltaModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Top Risk Factors")
                    .font(.headline)
                Spacer()
            }
            
            if lifeDeltaModel.currentDelta.topRiskFactors.isEmpty {
                Text("No significant risk factors identified")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(lifeDeltaModel.currentDelta.topRiskFactors) { factor in
                    HStack {
                        Image(systemName: factor.isPositive ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(factor.isPositive ? .green : .red)
                        
                        VStack(alignment: .leading) {
                            Text(factor.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(factor.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(factor.impact >= 0 ? "+" : "")\(Int(factor.impact)) days")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(factor.isPositive ? .green : .red)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct HealthDataCard: View {
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "heart.text.square")
                    .foregroundColor(.blue)
                Text("Health Data")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 10) {
                HealthDataRow(title: "Steps Today", value: "\(healthManager.currentHealthData.steps)", icon: "figure.walk")
                HealthDataRow(title: "Resting HR", value: "\(Int(healthManager.currentHealthData.restingHeartRate)) bpm", icon: "heart.fill")
                HealthDataRow(title: "Sleep", value: "\(healthManager.currentHealthData.sleepHours, specifier: "%.1f") hrs", icon: "moon.fill")
                HealthDataRow(title: "VO₂ Max", value: "\(Int(healthManager.currentHealthData.vo2Max))", icon: "lungs.fill")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct HealthDataRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct ShareButton: View {
    @State private var showingShareSheet = false
    
    var body: some View {
        Button(action: { showingShareSheet = true }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share Your Progress")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet()
        }
    }
}

struct ShareSheet: View {
    var body: some View {
        VStack {
            Text("Share your LifeDelta progress!")
                .font(.title2)
                .padding()
            
            // This would generate the actual shareable image
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Text("I gained +73 days!")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Download LifeDelta")
                            .font(.caption)
                    }
                )
                .padding()
            
            Spacer()
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(HealthManager())
        .environmentObject(LifeDeltaModel())
        .environmentObject(SubscriptionManager())
}
