import Foundation

struct GroceryItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
}
