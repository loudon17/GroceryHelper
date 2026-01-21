import SwiftUI

struct GroceryCardView: View {
    let title: String
    let replacementOptions: [String]

    @State private var items: [String]

    init(title: String, startingItems: [String], replacementOptions: [String]) {
        self.title = title
        self._items = State(initialValue: startingItems)
        self.replacementOptions = replacementOptions
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)

            ForEach(items.indices, id: \.self) { index in
                Menu {
                    ForEach(replacementOptions, id: \.self) { option in
                        Button(option) {
                            items[index] = option
                        }
                    }
                } label: {
                    HStack {
                        Text(items[index])
                            .font(.body.weight(.medium))
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(.orange)
                    }
                    .padding()
                    // MODIFICA QUI
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.orange, lineWidth: 2)
                    )
                }
            }

            Text("Tap an item to swap it with a better option.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
}
