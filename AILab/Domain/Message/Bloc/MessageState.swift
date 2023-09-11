//
//  MessageState.swift
//  AILab
//
//  Created by Aleksunder Volkov on 07.09.2023.
//  Copyright © 2023 TOO MDDT. All rights reserved.
//

import Foundation

enum MessageSearchStates {
    case inputState(Bool)
    case loading
    case messageFetched(String)
    case failure(Error)
    case noMessagesFound
}
