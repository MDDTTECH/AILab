//
//  MessageBloc.swift
//  AILab
//
//  Created by Aleksunder Volkov on 07.09.2023.
//  Copyright © 2023 TOO MDDT. All rights reserved.
//

import Foundation
import Combine

class MessageBloc: ObservableObject {

    // MARK: - View streams
    @Published
    var state: MessageSearchStates = MessageSearchStates.inputState(true)
    // TODO: Resolve
    private let repository: Messageable = MessageRepository()
    private var cancellables: Set<AnyCancellable> = []
    

    var event: MessageSearchEvents? {
        didSet {
            self.handleViewEvent(event: event)
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func handleViewEvent(event: MessageSearchEvents?) {

            switch event {
            case .answerSubmitted(let answer):
                state = MessageSearchStates.loading
                repository.send(request: answer)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case .failure(let error) = completion {
                            self.state = MessageSearchStates.failure(error)
                        }
                    } receiveValue: { resutMessage in
                        self.state = resutMessage.count > 0 ?
                        MessageSearchStates.messageFetched(resutMessage) :
                        MessageSearchStates.noMessagesFound
                    }
                    .store(in: &cancellables)
            case .questionRequested(let question):
                state = question.isEmpty ? MessageSearchStates.inputState(false) :  MessageSearchStates.inputState(true)
            case .none:
                print("Event subject recieved nil event")
            }
     }
}
