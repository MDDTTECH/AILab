//
//  MessageRepository.swift
//  AILab
//
//  Created by Aleksunder Volkov on 07.09.2023.
//  Copyright © 2023 TOO MDDT. All rights reserved.
//

import Foundation
import OpenAIKit
import Combine

enum MessageError: Error {
    case unknowned
    
    var description: String {
        switch self {
        case .unknowned:
            return "Unknown case"
        }
    }
}

protocol Messageable {
    func send(request: String) -> AnyPublisher<String, Error>
}

final class MessageRepository {
    public let openAI = OpenAIKit(
        apiToken: Constants.openAIToken,
        organization: Constants.openAIOrganization
    )
}

extension MessageRepository: Messageable {
    func send(request: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            self.openAI.sendCompletion(
                prompt: request,
                model: .gptV4(.gpt4),
                maxTokens: 2048) { result in
                    switch result {
                    case .success(let aiResult):
                        /// Handle success response result
                        if let text = aiResult.choices.first?.text {
                            print("response text: \(text)")
                            promise(.success(text))
                        } else {
                            promise(.failure(MessageError.unknowned))
                        }
                    case .failure(let error):
                        /// Handle error actions
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
