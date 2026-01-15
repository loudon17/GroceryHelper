import SwiftUI

struct FocusListsView: View {
    @State private var currentPage = 0

    private let basePresets: [[GroceryItem]] = [
        // Grocery
        [
            GroceryItem(name: "Coca-Cola", price: 5.00),
            GroceryItem(name: "Cake", price: 15.00),
            GroceryItem(name: "Olives", price: 7.00),
            GroceryItem(name: "Steak and fries", price: 22.00)
        ],
        // school
        [
            GroceryItem(name: "New textbook", price: 25.00),
            GroceryItem(name: "Set of 2 pens", price: 5.00),
            GroceryItem(name: "Set of 5 crayons", price: 12.00),
            GroceryItem(name: "Small notebook", price: 7.00)
        ],
        // party

        [
            GroceryItem(name: "Full set of decorations", price: 50.00),
            GroceryItem(name: "1 candle", price: 5.00),
            GroceryItem(name: "Mid size cake", price: 30.00),
            GroceryItem(name: "Champagne", price: 50.00)
        ],
        // Hygiene
        [
            GroceryItem(name: "Expensive pads", price: 8.00),
            GroceryItem(name: "Cheap lipstick", price: 4.00),
            GroceryItem(name: "Small bottle of perfume", price: 12.00),
            GroceryItem(name: "Package of 1 body soap", price: 6.00)
        ]
    ]
    
    private let replacementOptions: [[[GroceryItem]]] = [
        // Grocery
        [
            [GroceryItem(name: "Water", price: 1.50), GroceryItem(name: "Wine", price: 12.00)],
            [GroceryItem(name: "Fruit", price: 5.00), GroceryItem(name: "Dark Chocolate", price: 10.00)],
            [GroceryItem(name: "Chicken strips", price: 18.00), GroceryItem(name: "Crackers", price: 2.50)],
            [GroceryItem(name: "White Rice and zucchini", price: 6.50), GroceryItem(name: "Pasta Bolognese", price: 14.50)]
        ],
        //school
        [
            [GroceryItem(name: "Used textbook", price: 12.00), GroceryItem(name: "Lent textbook", price: 0.00)],
            [GroceryItem(name: "Set of 6 pens", price: 10.00), GroceryItem(name: "Set of 10 pens", price: 15.00)],
            [GroceryItem(name: "Set of 20 crayons", price: 25.00), GroceryItem(name: "Set of 10 crayons", price: 15.00)],
            [GroceryItem(name: "Big notebook", price: 15.00), GroceryItem(name: "Set of 3 notebooks", price: 35.00)]
        ],

        // party
        [
            [GroceryItem(name: "Party hats", price: 20.00), GroceryItem(name: "Confetti", price: 5.00)],
            [GroceryItem(name: "Set of 5 candles", price: 10.00)],
            [GroceryItem(name: "Small size cake", price: 15.00), GroceryItem(name: "Big size cake", price: 40.00)],
            [GroceryItem(name: "Water", price: 1.50), GroceryItem(name: "Fizzy drinks", price: 10.00)]
        ],
        // Hygiene
        [
            [GroceryItem(name: "Built pads", price: 1.00), GroceryItem(name: "Cheap pads", price: 4.00)],
            [GroceryItem(name: "Expensive lipstick", price: 150.00)],
            [GroceryItem(name: "Medium bottle of perfume", price: 30.00), GroceryItem(name: "Big bottle of perfume", price: 50.00)],
            [GroceryItem(name: "Package of 3 body soap", price: 15.00), GroceryItem(name: "Package of 5 body soap", price: 25.00)]
        ],
    ]

    private let titles = [
        "Grocery",
        "School",
        "Party",
        "Hygiene",
    ]

    @State private var listCurrentSavings: [Double] = Array(repeating: 0, count: 4)
    @State private var listMaxSavings: [Double] = Array(repeating: 0, count: 4)
    @State private var listProgress: [Double] = Array(repeating: 0, count: 4)

    private var totalCurrentSavings: Double {
        listCurrentSavings.reduce(0, +)
    }

    private var totalMaxSavings: Double {
        listMaxSavings.reduce(0, +)
    }

    private var totalSavingsProgress: Double {
        guard !listProgress.isEmpty else { return 0 }
        let combinedProgress = listProgress.reduce(0, +)
        return min(1, max(0, combinedProgress / Double(listProgress.count)))
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
                            onSavingsChange: { current, max, progress in
                                listCurrentSavings[index] = current
                                listMaxSavings[index] = max
                                listProgress[index] = progress
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
                            if currentPage < 4{
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
        .navigationTitle(currentPage < 3 ? titles[currentPage] : "Summary")
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
