//
//  StreamManager.swift
//  StreamChat
//
//  Created by steven on 8/11/21.
//

import Foundation

protocol StreamManagerDelegate: NSObject {
    func received(message: String)
}

class StreamManager: NSObject {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    weak var delegate: StreamManagerDelegate?
    
    func setup() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           ChatServerInfo.url as CFString,
                                           ChatServerInfo.port,
                                           &readStream,
                                           &writeStream)
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
    }
    
    func open() {
        inputStream?.open()
        outputStream?.open()
    }
    
    func close() {
        inputStream?.close()
        outputStream?.close()
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ChatServerInfo.maxMessageLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream?.read(buffer, maxLength: ChatServerInfo.maxMessageLength)
            
            guard numberOfBytesRead! >= 0, stream.streamError == nil else {
                break
            }
            
            guard let bufferString = buffer.toString(length: numberOfBytesRead) else {
                continue
            }
            delegate?.received(message: bufferString)
        }
    }
}

extension StreamManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard eventCode == Stream.Event.hasSpaceAvailable,
              let inputStream = aStream as? InputStream else {
            return
        }
        readAvailableBytes(stream: inputStream)
    }
}
