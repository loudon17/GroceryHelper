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

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                HStack {
                    Text("Initial Cost:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(String(format: "$%.2f", originalTotalPrice))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }

                Text(summaryText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(summaryColor)
                    .contentTransition(.numericText(value: priceDifference))
                    .animation(.snappy, value: priceDifference)
            }
            .padding(.top, 10)

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
                                Text(items[index].formattedPrice)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        // MODIFICA IMPORTANTE QUI SOTTO: rimosso max(0, ...) per passare anche valori negativi
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
