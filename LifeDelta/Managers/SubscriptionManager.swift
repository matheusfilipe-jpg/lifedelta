import Foundation
import StoreKit
import Combine

class SubscriptionManager: ObservableObject {
    @Published var isProUser = false
    @Published var isLoading = false
    @Published var products: [Product] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSubscriptionStatus()
        loadProducts()
    }
    
    private func loadSubscriptionStatus() {
        // Check if user has active subscription
        isProUser = UserDefaults.standard.bool(forKey: "isProUser")
    }
    
    private func loadProducts() {
        Task {
            do {
                let products = try await Product.products(for: ["com.ezmoney.lifedelta.pro.monthly", "com.ezmoney.lifedelta.pro.yearly"])
                await MainActor.run {
                    self.products = products
                }
            } catch {
                print("Failed to load products: \(error)")
            }
        }
    }
    
    func purchase(product: Product) async {
        isLoading = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await MainActor.run {
                        self.isProUser = true
                        UserDefaults.standard.set(true, forKey: "isProUser")
                    }
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    func restorePurchases() async {
        isLoading = true
        
        do {
            try await AppStore.sync()
            await MainActor.run {
                self.isProUser = UserDefaults.standard.bool(forKey: "isProUser")
            }
        } catch {
            print("Restore failed: \(error)")
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
}
