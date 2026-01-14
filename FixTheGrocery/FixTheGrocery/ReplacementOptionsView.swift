import SwiftUI

struct ReplacementOptionsView: View {
    let currentItem: GroceryItem
    let replacementOptions: [GroceryItem]
    let onSelect: (GroceryItem) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(replacementOptions, id: \.id) { option in
                        ReplacementOptionRow(
                            option: option,
                            currentItem: currentItem,
                            onSelect: onSelect
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .navigationTitle("Choose Replacement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
