import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 100) {
                HStack(spacing: 60) {
                    // Immagine del personaggio
                    Image("Group 118")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 12)

                    // Testo aggiornato: Più focus sul risparmio e meno sul "goal" generico
                    Text("""
                    "Hey! I've lost track of my spending lately. Can you help me spot the best savings opportunities to fix my budget?"
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
                        Text("Let's Start") // Testo del pulsante più invitante
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 28))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.accentColor.opacity(0.15))
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing) // Spostato a destra per seguire il flusso naturale
            }
            .padding(40)
        }
    }
}
