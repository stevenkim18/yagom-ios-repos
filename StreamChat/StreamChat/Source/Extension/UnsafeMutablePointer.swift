//
//  UnsafeMutablePointer.swift
//  StreamChat
//
//  Created by steven on 8/19/21.
//

import Foundation

extension UnsafeMutablePointer {
    func toString(length: Int?) -> String? {
        return String(bytesNoCopy: self,
                      length: length!,
                      encoding: .utf8,
                      freeWhenDone: true)
    }
}
