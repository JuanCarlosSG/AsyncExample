//
//  CustomTextField.swift
//  AsyncExample
//
//  Created by Juan Carlos Sánchez Gutiérrez on 07/04/22.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var textValue: String
    var body: some View {
        TextField(placeholder, text: self.$textValue)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)
            )
    }
}
