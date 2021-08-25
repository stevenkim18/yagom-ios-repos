//
//  ChatRoom.swift
//  StreamChat
//
//  Created by steven on 8/12/21.
//

import Foundation

class ChatRoom: NSObject, StreamManagerDelegate {
    let userName: String
    let streamManager: StreamManager
    var messages: [Message] = []
    
    init(userName: String, streamManager: StreamManager) {
        self.userName = userName
        self.streamManager = streamManager
        self.streamManager.setup()
        super.init()
        self.streamManager.delegate = self
    }
    
    func open() {
        self.streamManager.open()
        self.streamManager.send(message: "\(OutgoingMessage.enter(userName))")
    }
    
    func close() {
        self.streamManager.send(message: "\(OutgoingMessage.leave)")
        self.streamManager.close()
    }
    
    func send(message: String) {
        self.streamManager.send(message: "\(OutgoingMessage.send(message))")
    }
    
    func received(message: String) {
        messages.append(Message(buffer: message, username: userName))
    }
}
