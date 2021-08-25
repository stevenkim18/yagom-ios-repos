//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by steven on 8/11/21.
//

import XCTest
@testable import StreamChat

class StreamChatTests: XCTestCase {

    func test_메시지_전송() {
        let streamManager = StreamManager()
        let chatRoom = ChatRoom(userName: "steven", streamManager: streamManager)
        XCTAssertEqual(chatRoom.messages.count, 1)
        chatRoom.send(message: "hello!")
        XCTAssertEqual(chatRoom.messages.count, 2)
    }
    
}
