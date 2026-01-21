import SwiftUI

struct FocusListPage: View {
    let title: String
    private let originalItems: [GroceryItem]
    private let baseReplacements: [[GroceryItem]]
    let onSavingsChange: (Double, Double, Double) -> Void

    @State private var items: [GroceryItem]
    @State private var selectedItem: GroceryItem?

    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]

    init(title: String, startingItems: [GroceryItem], itemReplacements: [[GroceryItem]], onSavingsChange: @escaping (Double, Double, Double) -> Void) {
        self.title = title
        self.originalItems = startingItems
        self.baseReplacements = itemReplacements
        self.onSavingsChange = onSavingsChange
        self._items = State(initialValue: startingItems)
    }

    // MARK: - Price & Savings Logic

    private var originalTotalPrice: Double {
        originalItems.reduce(0) { $0 + $1.price }
    }

    private var currentTotalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }

    private var priceDifference: Double {
        originalTotalPrice - currentTotalPrice
    }

    private var progressValue: Double {
        guard !items.isEmpty else { return 0 }
        let totalProgress = items.indices.reduce(0.0) { partial, index in
            let original = originalItems[index]
            let options = [original] + baseReplacements[index]
            let prices = options.map { $0.price }

            guard let minPrice = prices.min(), let maxPrice = prices.max(), maxPrice > minPrice else { return partial + 1 }

            let currentPrice = items[index].price
            let normalized = (maxPrice - currentPrice) / (maxPrice - minPrice)
            return partial + min(1, max(0, normalized))
        }
        return totalProgress / Double(items.count)
    }

    private var summaryText: String {
        let diff = priceDifference
        if diff > 0 {
            return "You are saving \(String(format: "$%.2f", diff))"
        } else if diff < 0 {
            return "You are spending \(String(format: "$%.2f", abs(diff))) more"
        } else {
            return "Same cost as the starting list"
        }
    }

    private var summaryColor: Color {
        let diff = priceDifference
        if diff > 0 { return .green }
        if diff < 0 { return .red }
        return .secondary
    }

    private var maxSavings: Double {
        guard !items.isEmpty else { return 0 }
        let minTotal = items.indices.reduce(0.0) { partial, index in
            let original = originalItems[index]
            let options = [original] + baseReplacements[index]
            let minPrice = options.map { $0.price }.min() ?? original.price
            return partial + minPrice
        }
        return max(0, originalTotalPrice - minTotal)
    }

    private func replacementOptions(for index: Int) -> [GroceryItem] {
        let original = originalItems[index]
        let options = [original] + baseReplacements[index]
        let currentId = items[index].id
        return options.filter { $0.id != currentId }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {

            // MARK: - HEADER AGGIORNATO
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.headline)

                // BOX COSTI AFFIANCATI
                HStack(spacing: 40) {

                    // 1. Costo Iniziale
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Initial Cost")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)

                        Text(String(format: "$%.2f", originalTotalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }

                    Divider()
                        .frame(height: 40)

                    // 2. Costo Aggiornato
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Updated Cost")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)

                        Text(String(format: "$%.2f", currentTotalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                            // Colore dinamico: Verde (risparmio) o Rosso (spesa extra)
                            .foregroundStyle(priceDifference >= 0 ? .green : .red)
                            .contentTransition(.numericText(value: currentTotalPrice))
                            .animation(.snappy, value: currentTotalPrice)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )

                // Testo descrittivo sotto (es: "You are saving $5.00")
                Text(summaryText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(summaryColor)
                    .contentTransition(.numericText(value: priceDifference))
                    .animation(.snappy, value: priceDifference)
            }
            .padding(.top, 10)

            // MARK: - GRID ITEMS
            HStack(alignment: .top, spacing: 40) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items.indices, id: \.self) { index in
                        Button {
                            selectedItem = items[index]
                        } label: {
                            VStack(spacing: 8) {
                                Image(items[index].name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                Text(items[index].name)
                                    .font(.system(size: 20, weight: .semibold))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                Text(items[index].formattedPrice)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.gray)
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.title3)
                                    .foregroundStyle(.orange)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(Color.orange, lineWidth: 2)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onAppear {
            onSavingsChange(priceDifference, maxSavings, progressValue)
        }
        .onChange(of: items) { _ in
            onSavingsChange(priceDifference, maxSavings, progressValue)
        }
        .sheet(item: $selectedItem) { selected in
            if let index = items.firstIndex(where: { $0.id == selected.id }) {
                ReplacementOptionsView(
                    currentItem: items[index],
                    replacementOptions: replacementOptions(for: index),
                    onSelect: { selectedOption in
                        items[index] = selectedOption
                        selectedItem = nil
                    }
                )
            }
        }
    }
}
