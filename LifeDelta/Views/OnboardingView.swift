import SwiftUI
import HealthKit

struct OnboardingView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var currentStep = 0
    @State private var age = 30
    @State private var selectedSex: HKBiologicalSex = .notSet
    @State private var weight = 70.0
    @State private var height = 170.0
    
    private let totalSteps = 4
    
    var body: some View {
        VStack(spacing: 30) {
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.horizontal)
            
            Spacer()
            
            switch currentStep {
            case 0:
                welcomeStep
            case 1:
                ageStep
            case 2:
                sexStep
            case 3:
                measurementsStep
            default:
                permissionsStep
            }
            
            Spacer()
            
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(currentStep == totalSteps ? "Get Started" : "Next") {
                    if currentStep == totalSteps {
                        completeOnboarding()
                    } else {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.green)
                .cornerRadius(25)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Welcome to LifeDelta")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your personal longevity coach that shows how your daily habits impact your life expectancy")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    private var ageStep: some View {
        VStack(spacing: 20) {
            Text("What's your age?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Stepper(value: $age, in: 18...100) {
                Text("\(age) years old")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
    }
    
    private var sexStep: some View {
        VStack(spacing: 20) {
            Text("What's your biological sex?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 15) {
                Button(action: { selectedSex = .male }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Male")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedSex == .male ? Color.green : Color(.systemGray6))
                    .foregroundColor(selectedSex == .male ? .white : .primary)
                    .cornerRadius(15)
                }
                
                Button(action: { selectedSex = .female }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Female")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedSex == .female ? Color.green : Color(.systemGray6))
                    .foregroundColor(selectedSex == .female ? .white : .primary)
                    .cornerRadius(15)
                }
            }
        }
    }
    
    private var measurementsStep: some View {
        VStack(spacing: 20) {
            Text("Your measurements")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 15) {
                HStack {
                    Text("Weight")
                    Spacer()
                    Stepper(value: $weight, in: 30...200, step: 0.5) {
                        Text("\(weight, specifier: "%.1f") kg")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                HStack {
                    Text("Height")
                    Spacer()
                    Stepper(value: $height, in: 120...220, step: 1) {
                        Text("\(Int(height)) cm")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            }
        }
    }
    
    private var permissionsStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("Connect HealthKit")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("LifeDelta needs access to your health data to provide personalized insights and track your progress")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Grant Access") {
                healthManager.requestHealthKitPermissions()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.green)
            .cornerRadius(25)
        }
    }
    
    private func completeOnboarding() {
        healthManager.updateUserProfile(
            age: age,
            sex: selectedSex,
            weight: weight,
            height: height
        )
    }
}

#Preview {
    OnboardingView()
        .environmentObject(HealthManager())
}
