//
//  Message.swift
//  StreamChat
//
//  Created by steven on 8/13/21.
//

import Foundation

struct Message {
    let username: String
    let content: String
    let type: MessageType
    
    init(buffer: String, username: String) {
        if buffer.contains(MessageConstant.separator) {
            let strings = buffer.components(separatedBy: MessageConstant.separator)
            self.username = strings[0]
            self.content = strings[1]
            self.type = (self.username == username) ? .me : .other
        } else {
            self.username = ""
            self.content = buffer
            self.type = .system
        }
    }
}
