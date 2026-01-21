import SwiftUI

struct ReplacementOptionRow: View {
    let option: GroceryItem
    let currentItem: GroceryItem
    let onSelect: (GroceryItem) -> Void

    private var priceDiff: Double {
        option.price - currentItem.price
    }

    private var priceDiffText: String {
        if priceDiff < 0 {
            return "Save \(String(format: "$%.2f", abs(priceDiff)))"
        } else if priceDiff > 0 {
            return "+\(String(format: "$%.2f", priceDiff))"
        } else {
            return "Same price"
        }
    }

    private var priceDiffColor: Color {
        if priceDiff < 0 {
            return .green
        } else if priceDiff > 0 {
            return .orange
        } else {
            return .secondary
        }
    }

    var body: some View {
        Button {
            onSelect(option)
        } label: {
            HStack(spacing: 20) {
                Image(option.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(option.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.black) // Testo nero su sfondo bianco
                    Text(option.formattedPrice)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(priceDiffText)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(priceDiffColor)

                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.orange) // Accent arancione
                }
            }
            .padding(20)
            // MODIFICA QUI: Sfondo bianco e bordo arancione
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.orange, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
