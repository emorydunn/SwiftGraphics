//
//  String.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
import CommonCrypto

extension String {

    /// Return the SHA1 hash in a hex representation
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
