//
//  Message.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import Foundation

enum MessageType: String {
    case sent
    case received
}

struct Message {
    let text: String
    let type: MessageType
    let created: String //Date
}
