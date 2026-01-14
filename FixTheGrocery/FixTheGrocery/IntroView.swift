import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 100) {
                HStack(spacing: 60) {
                    Image("Group 118")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 12)

                    Text("""
                    "Hey, it's me. help me fix my grocery, i am out of focus in the latest days and I need help in reaching my goal."
                    """)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                )

                Spacer()

                NavigationLink {
                    FocusListsView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 28))
                        Text("Next")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.accentColor.opacity(0.15))
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(40)
        }
    }
}
