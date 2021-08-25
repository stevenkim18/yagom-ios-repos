//
//  OutgoingMessage.swift
//  StreamChat
//
//  Created by steven on 8/13/21.
//

import Foundation

enum OutgoingMessage {
    case enter(String)
    case send(String)
    case leave
}

extension OutgoingMessage: CustomStringConvertible {
    var description: String {
        switch self {
        case .enter(let user):
            return MessageConstant.userPrefix +
                    MessageConstant.separator +
                    user +
                    MessageConstant.separator +
                    MessageConstant.postfix
        case .send(let message):
            return MessageConstant.sendPrefix +
                    MessageConstant.separator +
                    message +
                    MessageConstant.separator +
                    MessageConstant.postfix
        case .leave:
            return MessageConstant.exitPrefix +
                    MessageConstant.separator +
                    MessageConstant.separator +
                    MessageConstant.postfix
        }
    }
}
