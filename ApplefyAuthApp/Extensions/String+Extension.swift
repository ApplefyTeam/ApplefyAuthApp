//
//  String+Extension.swift
//  ApplefyAuthApp
//
//  Created by Denys on 05.06.2023.
//

import Foundation

extension String {
    internal var dataUsingUTF8StringEncoding: Data {
        return utf8CString.withUnsafeBufferPointer {
            return Data($0.dropLast().map { UInt8.init($0) })
        }
    }
    
    /// Array<UInt8>
    internal var arrayUsingUTF8StringEncoding: [UInt8] {
        return utf8CString.withUnsafeBufferPointer {
            return $0.dropLast().map { UInt8.init($0) }
        }
    }
}
