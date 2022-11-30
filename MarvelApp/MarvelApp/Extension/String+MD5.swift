//
//  String+MD5.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import CommonCrypto

extension String {
    func md5()-> String {
        let data = Data(utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
