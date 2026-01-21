import SwiftUI

struct IntroView: View {
    var body: some View {
        // Usiamo ZStack con allineamento in basso a sinistra per l'immagine
        ZStack(alignment: .bottomLeading) {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("""
                    "Hello, I am Zaira, help me with this week shopping. I am out of focus in the latest days and I need help in reaching my goal."
                    """)
                    .font(.system(size: 20, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MY GOAL")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            Text("Fix the Roof")
                                .font(.headline)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        Image("FixingRoof")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 3)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemBackground).opacity(0.6))
                    )
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                // Sfondo terziario "container"
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                )
                .padding(.bottom, 270)
                .padding(.leading, 40) // Spostiamo leggermente a destra per bilanciare l'immagine a sinistra

                Spacer()

                NavigationLink {
                    FocusListsView()
                } label: {
                    HStack(spacing: 12) {
                        Text("Let's Start Saving")
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
                .frame(maxWidth: .infinity, alignment: .trailing) // Allinea a destra
                .padding(.bottom, 30) // Margine dal fondo
                .padding(.trailing, 30)
            }
            .padding(.top, 40) // Margine superiore


            Image("Woman")
                .resizable()
                .scaledToFit()
                .frame(height: 450) // Molto più grande (era 180)
                .shadow(color: .black.opacity(0.2), radius: 12, x: 5, y: 5) // Ombra per l'effetto "pop"
                .ignoresSafeArea(edges: .bottom) // Tocca il bordo inferiore dello schermo
                .offset(x: 50, y: 40) // Posizionamento fine nell'angolo sinistro
        }
    }
}
