//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftCrypto open source project
//
// Copyright (c) 2021-2024 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of SwiftCrypto project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import Crypto
#if canImport(Darwin) || swift(>=5.9.1)
import Foundation
#else
@preconcurrency import Foundation
#endif

#if canImport(CommonCrypto)
fileprivate typealias BackingPBKDF2 = CommonCryptoPBKDF2
#else
fileprivate typealias BackingPBKDF2 = BoringSSLPBKDF2
#endif

extension KDF.Insecure {
    /// An implementation of PBKDF2 key derivation function.
    public struct PBKDF2 {
        /// Derives a symmetric key using the PBKDF2 algorithm.
        ///
        /// - Parameters:
        ///    - password: The passphrase, which should be used as a basis for the key. This can be any type that conforms to `DataProtocol`, like `Data` or an array of `UInt8` instances.
        ///    - salt: The salt to use for key derivation.
        ///    - hashFunction: The hash function to use for key derivation.
        ///    - outputByteCount: The length in bytes of resulting symmetric key.
        ///    - rounds: The number of rounds which should be used to perform key derivation.
        /// - Returns: The derived symmetric key.
        public static func deriveKey<Passphrase: DataProtocol, Salt: DataProtocol>(from password: Passphrase, salt: Salt, using hashFunction: HashFunction, outputByteCount: Int, rounds: Int) throws -> SymmetricKey {
            return try BackingPBKDF2.deriveKey(from: password, salt: salt, using: hashFunction, outputByteCount: outputByteCount, rounds: rounds)
        }
        
        public struct HashFunction: Equatable, Hashable {
            public let rawValue: String
            
            public static let md5 = HashFunction(rawValue: "md5")
            public static let sha1 = HashFunction(rawValue: "sha1")
            public static let sha224 = HashFunction(rawValue: "sha224")
            public static let sha256 = HashFunction(rawValue: "sha256")
            public static let sha384 = HashFunction(rawValue: "sha384")
            public static let sha512 = HashFunction(rawValue: "sha512")
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
        }
    }
}
