import SwiftUI

struct BiDirectionalProgressBar: View {
    let value: Double // Range: -1.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let centerX = totalWidth / 2
            let halfWidth = totalWidth / 2
            let fillWidth = abs(value) * halfWidth
            let clampedValue = max(-1.0, min(1.0, value))
            
            ZStack(alignment: .leading) {
                // Gray track background
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                
                // Left side (for negative values) - red fill from center to left
                if clampedValue < 0 && fillWidth > 0 {
                    HStack(spacing: 0) {
                        // Clear space on the far left
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: centerX - fillWidth)
                        // Red fill from center going left
                        Capsule()
                            .fill(Color.red)
                            .frame(width: fillWidth)
                        // Clear space from center to right
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: centerX)
                    }
                }
                
                // Right side (for positive values)
                if clampedValue > 0 && fillWidth > 0 {
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: centerX)
                        Capsule()
                            .fill(Color.green)
                            .frame(width: fillWidth)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: centerX - fillWidth)
                    }
                }
                
                // Center vertical marker (overlay on top)
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: centerX - 1)
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 2)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: centerX - 1)
                }
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Value: -1.0 (Max Left)")
        BiDirectionalProgressBar(value: -1.0)
            .padding(.horizontal)
        
        Text("Value: -0.5 (Half Left)")
        BiDirectionalProgressBar(value: -0.5)
            .padding(.horizontal)
        
        Text("Value: 0.0 (Center)")
        BiDirectionalProgressBar(value: 0.0)
            .padding(.horizontal)
        
        Text("Value: 0.5 (Half Right)")
        BiDirectionalProgressBar(value: 0.5)
            .padding(.horizontal)
        
        Text("Value: 1.0 (Max Right)")
        BiDirectionalProgressBar(value: 1.0)
            .padding(.horizontal)
    }
    .padding()
}
