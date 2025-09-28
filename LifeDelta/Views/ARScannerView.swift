import SwiftUI
import AVFoundation
import Vision

struct ARScannerView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingPaywall = false
    @State private var showingCamera = false
    @State private var scannedFood: ScannedFood?
    @State private var showingResults = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if subscriptionManager.isProUser {
                    scannerContent
                } else {
                    paywallContent
                }
            }
            .padding()
            .navigationTitle("Food Scanner")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingCamera) {
                CameraView { food in
                    scannedFood = food
                    showingResults = true
                }
            }
            .sheet(isPresented: $showingResults) {
                if let food = scannedFood {
                    FoodResultsView(food: food)
                }
            }
        }
    }
    
    private var scannerContent: some View {
        VStack(spacing: 30) {
            // Scanner Icon
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Scan Your Food")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Point your camera at food to see how it impacts your life expectancy")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            // Scan Button
            Button(action: { showingCamera = true }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Start Scanning")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(15)
            }
            
            // Recent Scans
            RecentScansView()
        }
    }
    
    private var paywallContent: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Unlock Food Scanner")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Use AI to scan food and see its impact on your longevity")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                FeatureRow(icon: "camera.viewfinder", title: "AI Food Recognition", description: "Automatically identify food items from photos")
                FeatureRow(icon: "chart.bar.fill", title: "Nutritional Analysis", description: "Get detailed nutritional breakdown and life impact")
                FeatureRow(icon: "plus.circle.fill", title: "Life Delta Tracking", description: "See how each meal affects your life expectancy")
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

struct CameraView: UIViewControllerRepresentable {
    let onFoodScanned: (ScannedFood) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                analyzeFood(image: image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        private func analyzeFood(image: UIImage) {
            // Simulate food analysis
            let mockFood = ScannedFood(
                name: "Mixed Salad",
                confidence: 0.85,
                nutritionalInfo: NutritionalInfo(
                    calories: 150,
                    protein: 8.0,
                    carbs: 12.0,
                    fat: 6.0,
                    fiber: 4.0
                ),
                lifeDelta: 0.2, // +0.2 days
                timestamp: Date()
            )
            
            parent.onFoodScanned(mockFood)
        }
    }
}

struct ScannedFood: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    let nutritionalInfo: NutritionalInfo
    let lifeDelta: Double // days gained/lost
    let timestamp: Date
}

struct NutritionalInfo {
    let calories: Int
    let protein: Double // grams
    let carbs: Double // grams
    let fat: Double // grams
    let fiber: Double // grams
}

struct FoodResultsView: View {
    let food: ScannedFood
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Food Image Placeholder
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                Text(food.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        )
                    
                    // Life Delta
                    VStack(spacing: 10) {
                        Text("Life Impact")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: food.lifeDelta >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .foregroundColor(food.lifeDelta >= 0 ? .green : .red)
                            
                            Text("\(food.lifeDelta >= 0 ? "+" : "")\(food.lifeDelta, specifier: "%.2f") days")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(food.lifeDelta >= 0 ? .green : .red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Nutritional Info
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Nutritional Information")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            NutritionRow(label: "Calories", value: "\(food.nutritionalInfo.calories)", unit: "kcal")
                            NutritionRow(label: "Protein", value: "\(food.nutritionalInfo.protein, specifier: "%.1f")", unit: "g")
                            NutritionRow(label: "Carbs", value: "\(food.nutritionalInfo.carbs, specifier: "%.1f")", unit: "g")
                            NutritionRow(label: "Fat", value: "\(food.nutritionalInfo.fat, specifier: "%.1f")", unit: "g")
                            NutritionRow(label: "Fiber", value: "\(food.nutritionalInfo.fiber, specifier: "%.1f")", unit: "g")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Confidence
                    HStack {
                        Text("Recognition Confidence:")
                        Spacer()
                        Text("\(Int(food.confidence * 100))%")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Scan Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NutritionRow: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(value) \(unit)")
                .fontWeight(.medium)
        }
    }
}

struct RecentScansView: View {
    @State private var recentScans: [ScannedFood] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Scans")
                .font(.headline)
            
            if recentScans.isEmpty {
                Text("No recent scans")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(recentScans) { scan in
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading) {
                            Text(scan.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(scan.timestamp, style: .relative)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(scan.lifeDelta >= 0 ? "+" : "")\(scan.lifeDelta, specifier: "%.1f") days")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(scan.lifeDelta >= 0 ? .green : .red)
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

#Preview {
    ARScannerView()
        .environmentObject(SubscriptionManager())
}
