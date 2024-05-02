//
//  LargeButton.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-27.
//

import SwiftUI

struct LargeButtonLabel: View {
    var text: String
    var backGroundColor: Color
    var foreGroundColor: Color
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backGroundColor)
            .foregroundColor(foreGroundColor)
            .bold()
            .cornerRadius(20)
    }
}

#Preview {
    LargeButtonLabel(text:"Add new Habit", backGroundColor: .red, foreGroundColor: .white)
}
