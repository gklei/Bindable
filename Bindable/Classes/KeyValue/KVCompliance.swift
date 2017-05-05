//
//  KVCompliance.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public protocol KVKeyType: Hashable {
   var rawValue: String { get }
   init?(rawValue: String)
   func kvTypeError(value: Any?) -> KVError
   static var all: [Self] { get }
}

public extension KVKeyType {
   static var all: [Self] {
      var all: [Self] = []
      for element in iterateEnum(Self.self) {
         all.append(element)
      }
      return all
   }
   
   func kvTypeError(value: Any?) -> KVError {
      let valueString: String = {
         guard let value = value else { return "nil" }
         return "\(type(of: value))"
      }()

      return KVError.valueType(key: "\(type(of: self)).\(self.rawValue)", value: valueString)
   }
}

public enum KVError: Error {
   case valueType(key: String, value: String)
}

public protocol KVCompliance: KVStringCompliance {
   associatedtype Key: KVKeyType
   
   func value(for key: Key) -> Any?
   mutating func set(value: Any?, for key: Key) throws
}

public protocol KVComplianceClass: class, KVCompliance {
   func set(value: Any?, for key: Key) throws
}
