import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingPaywall = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                // User Info Section
                Section {
                    UserInfoRow()
                }
                
                // Subscription Section
                Section("Subscription") {
                    SubscriptionRow()
                }
                
                // Health Data Section
                Section("Health Data") {
                    HealthDataRow(title: "Age", value: "\(healthManager.currentHealthData.age) years")
                    HealthDataRow(title: "Weight", value: "\(healthManager.currentHealthData.weight, specifier: "%.1f") kg")
                    HealthDataRow(title: "Height", value: "\(Int(healthManager.currentHealthData.height)) cm")
                    HealthDataRow(title: "BMI", value: "\(healthManager.currentHealthData.bmi, specifier: "%.1f")")
                }
                
                // Settings Section
                Section("Settings") {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink(destination: DataExportView()) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    
                    NavigationLink(destination: PrivacyView()) {
                        Label("Privacy", systemImage: "hand.raised.fill")
                    }
                }
                
                // Support Section
                Section("Support") {
                    Link(destination: URL(string: "mailto:support@lifedelta.app")!) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                    
                    Link(destination: URL(string: "https://lifedelta.app/help")!) {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                }
                
                // Legal Section
                Section("Legal") {
                    Link(destination: URL(string: "https://lifedelta.app/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    
                    Link(destination: URL(string: "https://lifedelta.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct UserInfoRow: View {
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        HStack {
            // Profile Picture Placeholder
            Circle()
                .fill(Color.green.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text("LifeDelta User")
                    .font(.headline)
                
                Text("Member since \(Date(), style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

struct SubscriptionRow: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingPaywall = false
    
    var body: some View {
        HStack {
            Image(systemName: subscriptionManager.isProUser ? "crown.fill" : "crown")
                .foregroundColor(subscriptionManager.isProUser ? .yellow : .gray)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(subscriptionManager.isProUser ? "Pro Member" : "Free Plan")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subscriptionManager.isProUser ? "Full access to all features" : "Upgrade for advanced features")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !subscriptionManager.isProUser {
                Button("Upgrade") {
                    showingPaywall = true
                }
                .font(.caption)
                .foregroundColor(.green)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
}

struct HealthDataRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var showingOnboarding = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            Section("Health Data") {
                Button("Reconnect HealthKit") {
                    healthManager.requestHealthKitPermissions()
                }
                
                Button("Refresh Health Data") {
                    healthManager.fetchHealthData()
                }
            }
            
            Section("Account") {
                Button("Reset Onboarding") {
                    showingOnboarding = true
                }
                
                Button("Delete All Data", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
            
            Section("Notifications") {
                Toggle("Weekly Digest", isOn: .constant(true))
                Toggle("Life Delta Updates", isOn: .constant(true))
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Delete all data
            }
        } message: {
            Text("This will permanently delete all your health data and cannot be undone.")
        }
    }
}

struct DataExportView: View {
    @State private var isExporting = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Export Your Data")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Download all your health data and life expectancy calculations in a PDF format")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                FeatureRow(icon: "doc.text.fill", title: "Complete Health History", description: "All your health data and trends")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Life Delta Analysis", description: "Detailed breakdown of habit impacts")
                FeatureRow(icon: "lock.fill", title: "Privacy Protected", description: "Your data is encrypted and secure")
            }
            
            Button(action: { isExporting = true }) {
                HStack {
                    if isExporting {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "square.and.arrow.down")
                    }
                    Text(isExporting ? "Exporting..." : "Export Data")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(15)
            }
            .disabled(isExporting)
        }
        .padding()
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Privacy Matters")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 15) {
                    PrivacyFeature(
                        icon: "iphone",
                        title: "On-Device Processing",
                        description: "All health data processing happens on your device. Nothing is sent to our servers."
                    )
                    
                    PrivacyFeature(
                        icon: "lock.fill",
                        title: "Encrypted Storage",
                        description: "Your data is encrypted using AES-256 encryption and stored securely on your device."
                    )
                    
                    PrivacyFeature(
                        icon: "eye.slash.fill",
                        title: "No Data Sharing",
                        description: "We never share your health data with third parties or advertisers."
                    )
                    
                    PrivacyFeature(
                        icon: "trash.fill",
                        title: "Full Control",
                        description: "You can export or delete all your data at any time."
                    )
                }
                
                Text("LifeDelta is designed with privacy-first principles. Your health data never leaves your device, ensuring complete privacy and security.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyFeature: View {
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
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(HealthManager())
        .environmentObject(SubscriptionManager())
}
