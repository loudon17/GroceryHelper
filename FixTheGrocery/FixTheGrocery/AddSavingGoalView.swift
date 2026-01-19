//
//  AddSavingGoalView.swift
//  FixTheGrocery
//
//  Created by Antonio Esposito on 16/01/26.
//

import SwiftUI

struct AddSavingGoalView: View {
    @State private var selectedGoal: SavingGoal? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let totalSpacing: CGFloat = 28 * CGFloat(savingGoals.count - 1)
            let horizontalPadding: CGFloat = geometry.size.width * 0.04
            let buttonWidth = (geometry.size.width - totalSpacing - horizontalPadding * 2) / CGFloat(savingGoals.count)
            let buttonHeight = buttonWidth * 1.3

            VStack(alignment: .center, spacing: 20) {
                Text("Choose a saving goal")
                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.05))
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, horizontalPadding * 0.7)
                
                HStack(spacing: 28) {
                    ForEach(savingGoals, id: \.name) { goal in
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedGoal = (selectedGoal == goal) ? nil : goal
                            }
                        }) {
                            VStack(spacing: 16) {
                                Image(goal.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: buttonHeight * 0.4)
                                Text(goal.name)
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                Text("$\(Int(goal.cost))")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 48)
                                        .fill(Color.orange.opacity(0.5))
                                    RoundedRectangle(cornerRadius: 48)
                                        .fill(Color.orange)
                                        .padding(6)
                                }
                            )
                            .cornerRadius(48)
                        }
                        .scaleEffect(selectedGoal == goal ? 1.1 : 0.95)
                        .opacity(selectedGoal == goal ? 1.0 : 0.6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedGoal)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .frame(height: geometry.size.height * 0.75) // Reduced height to make space
                .background(Color.white)
                
                // Fixed arrow button - contained within bounds
                HStack {
                    Spacer()
                    NavigationLink(destination: IntroView()) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 48)
                                        .fill(Color.orange.opacity(0.5))
                                        .opacity(selectedGoal != nil ? 1.0 : 0.6)
                                    RoundedRectangle(cornerRadius: 48)
                                        .fill(Color.orange)
                                        .opacity(selectedGoal != nil ? 1.0 : 0.6)
                                        .padding(6)
                                })
                            .padding(.trailing, 50)
                    }
                    
                    .scaleEffect(selectedGoal != nil ? 1.0 : 0.6)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedGoal)
                    .buttonStyle(PlainButtonStyle())
                }
               // .padding(.horizontal, horizontalPadding * 2) // Same padding as buttons
              //  .frame(height: buttonHeight * 0.4) // Fixed height
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white)
        }
    }
}





#Preview {
    AddSavingGoalView()
}
