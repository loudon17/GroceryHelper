import SwiftUI

struct FocusListsView: View {
    @State private var currentPage = 0

    private let basePresets: [[GroceryItem]] = [
        // Grocery
        [
            GroceryItem(name: "Coca-Cola", price: 5.00),
            GroceryItem(name: "Cake", price: 15.00),
            GroceryItem(name: "Olives", price: 7.00),
            GroceryItem(name: "Burger", price: 22.00)
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
            [GroceryItem(name: "Fancy appetizers", price: 18.00), GroceryItem(name: "Crackers", price: 2.50)],
            [GroceryItem(name: "White Rice and zucchini", price: 6.50), GroceryItem(name: "Pasta Bolognese", price: 14.50)]
        ],
        // school
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
            [GroceryItem(name: "Expensive lipstick", price: 20.00)],
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

    // Somma di tutte le differenze (positivo = risparmio, negativo = spesa extra)
    private var totalDifference: Double {
        listCurrentSavings.reduce(0, +)
    }

    // Calcolo del costo totale iniziale (base fissa)
    private var totalInitialCost: Double {
        basePresets.flatMap { $0 }.reduce(0) { $0 + $1.price }
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
                            onSavingsChange: { currentDiff, max, progress in
                                // currentDiff ora può essere positivo o negativo
                                listCurrentSavings[index] = currentDiff
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
                        initialCost: totalInitialCost,
                        totalDifference: totalDifference
                    )
                    .tag(4)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation controls
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

// MARK: - Summary View Aggiornata
private struct TotalSavingsSummaryView: View {
    let initialCost: Double
    let totalDifference: Double

    // Calcolo dinamico del costo finale totale
    private var finalCost: Double {
        initialCost - totalDifference
    }

    var body: some View {
        VStack(spacing: 30) {

            Image("WomanHappy") // Asset immagine esistente
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

            Text("All Lists Completed!")
                .font(.title)
                .fontWeight(.bold)

            // CARD DEI TOTALI
            VStack(spacing: 24) {

                // HSTACK: Initial Cost vs Final Cost
                HStack(spacing: 40) {
                    // 1. Costo Iniziale Totale
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Initial")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)

                        Text(String(format: "$%.2f", initialCost))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }

                    Divider()
                        .frame(height: 40)

                    // 2. Costo Finale Totale
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Final")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)

                        Text(String(format: "$%.2f", finalCost))
                            .font(.title2)
                            .fontWeight(.bold)
                            // Colore dinamico: Verde se risparmio, Rosso se spesa extra
                            .foregroundStyle(totalDifference >= 0 ? .green : .red)
                    }
                }

                Divider()

                // 3. Testo di Riepilogo (Saved / Extra)
                if totalDifference > 0 {
                    Text("You saved a total of \(String(format: "$%.2f", totalDifference))!")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else if totalDifference < 0 {
                    Text("You spent \(String(format: "$%.2f", abs(totalDifference))) extra.")
                        .font(.headline)
                        .foregroundStyle(.red)
                } else {
                    Text("Total cost remained the same.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )

            Spacer()
        }
    }
}
