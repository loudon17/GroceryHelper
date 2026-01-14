import SwiftUI

struct FocusListsView: View {
    @State private var currentPage = 0

    private let basePresets: [[GroceryItem]] = [
        // Grocery
        [
            GroceryItem(name: "Coca-Cola", price: 2.50),
            GroceryItem(name: "Cake", price: 15.00),
            GroceryItem(name: "Bread", price: 3.50),
            GroceryItem(name: "Pasta", price: 2.00)
        ],
        // Hygiene
        [
            GroceryItem(name: "Fancy Shampoo", price: 25.00),
            GroceryItem(name: "Toothbrush", price: 5.00),
            GroceryItem(name: "Hair Balsam", price: 12.00),
            GroceryItem(name: "Body Lotion", price: 10.00)
        ],
        // Furniture & Appliances
        [
            GroceryItem(name: "Chair", price: 85.00),
            GroceryItem(name: "Fridge", price: 800.00),
            GroceryItem(name: "Oven", price: 600.00),
            GroceryItem(name: "Bed", price: 500.00)
        ],
        // House Supplies
        [
            GroceryItem(name: "Laundry Detergent", price: 14.00),
            GroceryItem(name: "Scrub Brush", price: 4.00),
            GroceryItem(name: "Light Bulbs", price: 12.00),
            GroceryItem(name: "Paper Towels", price: 6.00)
        ]
    ]
    
    private let replacementOptions: [[[GroceryItem]]] = [
        // Grocery
        [
            [GroceryItem(name: "Water", price: 1.50), GroceryItem(name: "Wine", price: 12.00), GroceryItem(name: "Beer", price: 8.00)],  // Coca-Cola
            [GroceryItem(name: "Fruit", price: 5.00), GroceryItem(name: "Greek Yogurt", price: 6.00), GroceryItem(name: "Dark Chocolate", price: 4.00)],  // Cake
            [GroceryItem(name: "Rice Cakes", price: 3.00), GroceryItem(name: "Tortilla Wraps", price: 4.00), GroceryItem(name: "Crackers", price: 2.50)],  // Bread
            [GroceryItem(name: "White Rice", price: 2.50), GroceryItem(name: "Orzo", price: 3.00), GroceryItem(name: "Farro", price: 4.50)]  // Pasta
        ],
        // Hygiene
        [
            [GroceryItem(name: "Standard Shampoo", price: 8.00), GroceryItem(name: "Dry Shampoo", price: 10.00), GroceryItem(name: "Cleansing Bar", price: 5.00)],  // Fancy Shampoo
            [GroceryItem(name: "Electric Toothbrush", price: 60.00), GroceryItem(name: "Mouthwash", price: 7.00), GroceryItem(name: "Dental Floss", price: 4.00)],  // Toothbrush
            [GroceryItem(name: "Hair Mask", price: 15.00), GroceryItem(name: "Argan Oil", price: 18.00), GroceryItem(name: "Leave-in Spray", price: 11.00)],  // Hair Balsam
            [GroceryItem(name: "Body Butter", price: 15.00), GroceryItem(name: "Coconut Oil", price: 9.00), GroceryItem(name: "Aloe Vera Gel", price: 8.00)]  // Body Lotion
        ],
        // Furniture & Appliances
        [
            [GroceryItem(name: "Stool", price: 45.00), GroceryItem(name: "Bench", price: 120.00), GroceryItem(name: "Armchair", price: 250.00)],  // Chair
            [GroceryItem(name: "Mini-fridge", price: 150.00), GroceryItem(name: "Chest Freezer", price: 250.00), GroceryItem(name: "Wine Cooler", price: 350.00)],  // Fridge
            [GroceryItem(name: "Microwave", price: 120.00), GroceryItem(name: "Air Fryer", price: 100.00), GroceryItem(name: "Toaster Oven", price: 80.00)],  // Oven
            [GroceryItem(name: "Sofa Bed", price: 450.00), GroceryItem(name: "Futon", price: 200.00), GroceryItem(name: "Daybed", price: 350.00)]  // Bed
        ],
        // House Supplies
        [
            [GroceryItem(name: "Soap Flakes", price: 8.00), GroceryItem(name: "Baking Soda & Vinegar", price: 5.00), GroceryItem(name: "Detergent Pods", price: 18.00)],  // Laundry Detergent
            [GroceryItem(name: "Sponge", price: 2.00), GroceryItem(name: "Microfiber Cloth", price: 3.00), GroceryItem(name: "Steel Wool", price: 5.00)],  // Scrub Brush
            [GroceryItem(name: "LED Bulbs", price: 15.00), GroceryItem(name: "Smart Bulbs", price: 35.00), GroceryItem(name: "Halogen Lamps", price: 10.00)],  // Light Bulbs
            [GroceryItem(name: "Dish Towels", price: 12.00), GroceryItem(name: "Reusable Rags", price: 10.00), GroceryItem(name: "Newspaper", price: 2.00)]  // Paper Towels
        ]
    ]

    private let titles = [
        "Grocery",
        "Hygiene",
        "Furniture & Appliances",
        "House Supplies"
    ]

    @State private var listCurrentSavings: [Double] = Array(repeating: 0, count: 4)
    @State private var listMaxSavings: [Double] = Array(repeating: 0, count: 4)

    private var totalCurrentSavings: Double {
        listCurrentSavings.reduce(0, +)
    }

    private var totalMaxSavings: Double {
        listMaxSavings.reduce(0, +)
    }

    private var totalSavingsProgress: Double {
        guard totalMaxSavings > 0 else { return 0 }
        return min(1, max(0, totalCurrentSavings / totalMaxSavings))
    }

    private var totalSavingsText: String {
        if totalCurrentSavings <= 0 {
            return "We haven't saved anything yet, but we're just getting started."
        } else {
            return "Together we saved \(String(format: "$%.2f", totalCurrentSavings)) across all lists!"
        }
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    // Four focus lists (0...3)
                    ForEach(0..<4) { index in
                        FocusListPage(
                            title: titles[index],
                            startingItems: basePresets[index],
                            itemReplacements: replacementOptions[index],
                            onSavingsChange: { current, max in
                                listCurrentSavings[index] = current
                                listMaxSavings[index] = max
                            }
                        )
                        .tag(index)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                    }

                    // Final summary page (index 4)
                    TotalSavingsSummaryView(
                        totalSavingsText: totalSavingsText,
                        totalSavingsProgress: totalSavingsProgress
                    )
                    .tag(4)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 24) {
                    HStack(spacing: 20) {
                        Button {
                            if currentPage > 0 {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left.circle.fill")
                                    .font(.title2)
                                Text("Previous")
                                    .font(.headline)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(currentPage > 0 ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                            )
                        }
                        .disabled(currentPage == 0)

                        Text("\(currentPage + 1) / 5")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Button {
                            if currentPage < 4 {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Next")
                                    .font(.headline)
                                Image(systemName: "chevron.right.circle.fill")
                                    .font(.title2)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                .fill(currentPage < 4 ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                            )
                        }
                        .disabled(currentPage == 4)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(currentPage < 4 ? titles[currentPage] : "Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TotalSavingsSummaryView: View {
    let totalSavingsText: String
    let totalSavingsProgress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 20) {
                Image("Group 118")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(radius: 10)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Thank you for the help!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(totalSavingsText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Total savings progress")
                    .font(.headline)

                ProgressView(value: totalSavingsProgress)
                    .tint(.green)
            }

            Spacer()
        }
    }
}
