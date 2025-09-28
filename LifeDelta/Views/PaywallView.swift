import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Unlock LifeDelta Pro")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Get the most out of your longevity journey")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Features
                    VStack(spacing: 20) {
                        ProFeature(
                            icon: "slider.horizontal.3",
                            title: "Habit Simulator",
                            description: "See how lifestyle changes impact your life expectancy"
                        )
                        
                        ProFeature(
                            icon: "camera.viewfinder",
                            title: "AR Food Scanner",
                            description: "Scan food to see nutritional impact on longevity"
                        )
                        
                        ProFeature(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Advanced Analytics",
                            description: "Detailed insights and trend analysis"
                        )
                        
                        ProFeature(
                            icon: "square.and.arrow.up",
                            title: "Share Progress",
                            description: "Create beautiful cards to share your gains"
                        )
                        
                        ProFeature(
                            icon: "envelope.fill",
                            title: "Weekly Digest",
                            description: "Personalized email summaries of your progress"
                        )
                        
                        ProFeature(
                            icon: "shield.fill",
                            title: "Streak Insurance",
                            description: "Protect your progress with streak insurance"
                        )
                    }
                    
                    // Pricing
                    VStack(spacing: 15) {
                        Text("Choose Your Plan")
                            .font(.headline)
                        
                        if !subscriptionManager.products.isEmpty {
                            ForEach(subscriptionManager.products, id: \.id) { product in
                                PricingCard(
                                    product: product,
                                    isSelected: selectedProduct?.id == product.id
                                ) {
                                    selectedProduct = product
                                }
                            }
                        } else {
                            // Fallback pricing if products don't load
                            PricingCard(
                                title: "Yearly",
                                price: "$19",
                                period: "per year",
                                savings: "Save 37%",
                                isSelected: selectedProduct?.id == "yearly"
                            ) {
                                // Mock selection
                            }
                            
                            PricingCard(
                                title: "Monthly",
                                price: "$2.99",
                                period: "per month",
                                savings: nil,
                                isSelected: selectedProduct?.id == "monthly"
                            ) {
                                // Mock selection
                            }
                        }
                    }
                    
                    // Purchase Button
                    Button(action: purchaseSelectedProduct) {
                        HStack {
                            if subscriptionManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "crown.fill")
                            }
                            Text(subscriptionManager.isLoading ? "Processing..." : "Start Free Trial")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                    }
                    .disabled(subscriptionManager.isLoading || selectedProduct == nil)
                    
                    // Restore Purchases
                    Button("Restore Purchases") {
                        Task {
                            await subscriptionManager.restorePurchases()
                        }
                    }
                    .foregroundColor(.secondary)
                    
                    // Terms
                    Text("7-day free trial, then $19/year. Cancel anytime. Terms apply.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Upgrade to Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if selectedProduct == nil && !subscriptionManager.products.isEmpty {
                selectedProduct = subscriptionManager.products.first
            }
        }
    }
    
    private func purchaseSelectedProduct() {
        guard let product = selectedProduct else { return }
        
        Task {
            await subscriptionManager.purchase(product: product)
            if subscriptionManager.isProUser {
                dismiss()
            }
        }
    }
}

struct ProFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)
            
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

struct PricingCard: View {
    let product: Product?
    let title: String?
    let price: String?
    let period: String?
    let savings: String?
    let isSelected: Bool
    let onTap: () -> Void
    
    init(product: Product, isSelected: Bool, onTap: @escaping () -> Void) {
        self.product = product
        self.title = nil
        self.price = nil
        self.period = nil
        self.savings = nil
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    init(title: String, price: String, period: String, savings: String?, isSelected: Bool, onTap: @escaping () -> Void) {
        self.product = nil
        self.title = title
        self.price = price
        self.period = period
        self.savings = savings
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(displayTitle)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        if let savings = displaySavings {
                            Text(savings)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(displayPrice)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(displayPeriod)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .gray)
                    .font(.title2)
            }
            .padding()
            .background(isSelected ? Color.green.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var displayTitle: String {
        if let product = product {
            return product.displayName
        } else if let title = title {
            return title
        }
        return ""
    }
    
    private var displayPrice: String {
        if let product = product {
            return product.displayPrice
        } else if let price = price {
            return price
        }
        return ""
    }
    
    private var displayPeriod: String {
        if let product = product {
            return product.subscription?.subscriptionPeriod.unit == .year ? "per year" : "per month"
        } else if let period = period {
            return period
        }
        return ""
    }
    
    private var displaySavings: String? {
        if let product = product {
            // Calculate savings for yearly vs monthly
            return nil
        } else {
            return savings
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(SubscriptionManager())
}
