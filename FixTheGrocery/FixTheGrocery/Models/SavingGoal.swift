//
//  SavingGoal.swift
//  FixTheGrocery
//
//  Created by Antonio Esposito on 16/01/26.
//

import Foundation
struct SavingGoal: Equatable {
    let name: String
    let imageName: String
    let cost: Double
}

let savingGoals: [SavingGoal] = [
    SavingGoal(name: "Sewing machine", imageName: "sewingMachine", cost: 230.0),
    SavingGoal(name: "Fixing the roof", imageName: "house", cost: 350.0),
    SavingGoal(name: "Medical Treatment", imageName: "medicine", cost: 250.0)
]
