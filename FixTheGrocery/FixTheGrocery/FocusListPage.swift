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

    // MARK: - Progress & savings

    /// Total you spend with the original items in this focus list
    private var originalTotalPrice: Double {
        originalItems.reduce(0) { $0 + $1.price }
    }

    /// Total you spend with the current choices
    private var currentTotalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }

    /// How much you are currently saving compared to the original list (never negative)
    private var currentSavings: Double {
        max(0, originalTotalPrice - currentTotalPrice)
    }

    /// Progress goes from -1.0 to 1.0.
    /// 0.0 means the current price equals the original price.
    /// 1.0 means the current price is the cheapest possible (min).
    /// -1.0 means the current price is the most expensive possible (max).
    private func itemProgress(at index: Int) -> Double {
        let original = originalItems[index]
        let originalPrice = original.price
        let currentPrice = items[index].price
        let options = [original] + baseReplacements[index]
        let prices = options.map { $0.price }

        guard
            let minPrice = prices.min(),
            let maxPrice = prices.max()
        else { return 0 } // Only one price option, equals original

        let delta = originalPrice - currentPrice

        // Positive delta: savings (current < original)
        if delta > 0 {
            let savingsRange = originalPrice - minPrice
            guard savingsRange > 0 else { 
                // Original is already the min, but current is even cheaper (shouldn't happen)
                return currentPrice < originalPrice ? 1.0 : 0.0
            }
            let normalized = delta / savingsRange
            return min(1.0, max(0.0, normalized))
        }
        // Negative delta: extra cost (current > original)
        else if delta < 0 {
            let extraCostRange = maxPrice - originalPrice
            guard extraCostRange > 0 else { 
                // Original is already the max, but current is even more expensive (shouldn't happen)
                return currentPrice > originalPrice ? -1.0 : 0.0
            }
            let normalized = delta / extraCostRange
            return max(-1.0, min(0.0, normalized))
        }
        // delta == 0: current equals original
        else {
            // If original equals max, return -1.0 (we're at most expensive)
            if originalPrice == maxPrice {
                return -1.0
            }
            // If original equals min, return 1.0 (we're at cheapest)
            if originalPrice == minPrice {
                return 1.0
            }
            // Otherwise, return 0.0 (we're at original, which is somewhere in between)
            return 0.0
        }
    }

    private var progressValue: Double {
        guard !items.isEmpty else { return 0 }

        let totalProgress = items.indices.reduce(0.0) { partial, index in
            partial + itemProgress(at: index)
        }

        return totalProgress / Double(items.count)
    }

    private var savingsText: String {
        if currentSavings <= 0 {
            return "No savings yet. Try swapping to cheaper options."
        } else {
            return "You are saving \(String(format: "$%.2f", currentSavings)) on this list."
        }
    }

    /// Maximum possible savings for this list if you pick the cheapest option in every slot
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

    // Replacement options for a specific slot, computed dynamically so the
    // previous choice always goes back into the list and the current choice is removed.
    private func replacementOptions(for index: Int) -> [GroceryItem] {
        let original = originalItems[index]
        let options = [original] + baseReplacements[index]
        let currentId = items[index].id
        return options.filter { $0.id != currentId }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Progress bar / savings header instead of image
            VStack(alignment: .leading, spacing: 12) {
                Text("\(title) savings")
                    .font(.headline)

                BiDirectionalProgressBar(value: progressValue)
                    .frame(maxWidth: .infinity)

                Text(savingsText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

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
        .onAppear {
            onSavingsChange(currentSavings, maxSavings, progressValue)
        }
        .onChange(of: items) { _ in
            onSavingsChange(currentSavings, maxSavings, progressValue)
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
