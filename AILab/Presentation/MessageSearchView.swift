//
//  MessageSearchView.swift
//  AILab
//
//  Created by Aleksunder Volkov on 07.09.2023.
//  Copyright © 2023 TOO MDDT. All rights reserved.
//

import SwiftUI

struct MessageSearchView: View {
    
    @StateObject
    var bloc = MessageBloc()
    
    @State
    var answer: String = " "
    
    var body: some View {
        VStack {
            switch bloc.state {
            case .inputState(let isValid):
                inputView(isValid: isValid)
            case .loading:
                ProgressView()
            case .messageFetched(let answer):
                Text(answer)
            case .failure(let error):
                Text(error.localizedDescription)
            case .noMessagesFound:
                Text("No answer found")
            }
        }
    }
    
    @ViewBuilder
    private func inputView(isValid: Bool) -> some View {
        VStack(alignment: .center, spacing: 5.0) {
            TextField("Enter your question here", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Answer is Empty")
                .foregroundColor(.red)
                .font(.caption)
                .isHidden(isValid) 
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("Question") {
                bloc.event = MessageSearchEvents.answerSubmitted(answer)
            }
            .disabled(!isValid)
        }
        .padding()
    }
}
