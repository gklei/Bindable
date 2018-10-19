//
//  DictionaryInitable.swift
//  Pods
//
//  Created by Leif Meyer on 7/7/17.
//
//

import Foundation

public enum IncDictionaryError: Error {
   case invalidType(selfType: String, valueType: String)
   case invalidValue(selfType: String, value: String)
}

public protocol IncDictionaryInitable {
   init?(dictionary: Any) throws
}

public protocol IncKVDictionaryInitable: IncDictionaryInitable, IncKVCompliance {
   static var dictionaryKeys: [Key] { get }
   static var dictionaryPath: [String] { get }
   init()
}

public enum IncKVDictionaryError: Error {
   case underlyingError(selfType: String, key: String, error: Error)
}

public extension IncDictionaryInitable {
   // MARK: - Error creation
   static func dictionaryTypeError(value: Any) -> IncDictionaryError { return .invalidType(selfType: "\(Self.self)", valueType: "\(type(of: value))") }
   
   static func dictionaryValueError(value: Any) -> IncDictionaryError { return .invalidValue(selfType: "\(Self.self)", value: "\(value)") }
}

public extension IncKVDictionaryInitable {
   static var dictionaryKeys: [Key] { return Key.all }
   static var dictionaryPath: [String] { return [] }
   
   static func kvDictionaryUnderlyingError(key: Key, error: Error) -> IncKVDictionaryError { return .underlyingError(selfType: "\(Self.self)", key: key.rawValue, error: error) }

   init(dictionary: [String : Any]) throws {
      self.init()
      var dictionary = dictionary
      try type(of: self).dictionaryPath.forEach {
         guard let value = dictionary[$0] as? [String : Any] else { throw type(of: self).dictionaryTypeError(value: dictionary) }
         dictionary = value
      }
      try update(with: dictionary)
   }
   
   mutating func update(with dictionary: [String : Any]) throws {
      try type(of: self).dictionaryKeys.forEach {
         do {
            try self.set(value: dictionary[$0.rawValue], for: $0)
         } catch {
            throw type(of: self).kvDictionaryUnderlyingError(key: $0, error: error)
         }
      }
   }
}

public protocol IncKVDictionaryInitableClass: class, IncKVDictionaryInitable, IncKVComplianceClass {}

public extension IncKVDictionaryInitableClass {
   func update(with dictionary: [String : Any]) throws {
      try type(of: self).dictionaryKeys.forEach {
         do {
            try self.set(value: dictionary[$0.rawValue], for: $0)
         } catch {
            throw type(of: self).kvDictionaryUnderlyingError(key: $0, error: error)
         }
      }
   }
}

public protocol IncKVDictionaryInitableRepresentable: IncKVDictionaryInitable, IncKVDictionaryRepresentable {}

public extension IncKVDictionaryInitableRepresentable {
   static var dictionaryKeys: [Key] { return Key.all }
}

public protocol IncKVDictionaryInitableRepresentableClass: IncKVDictionaryInitableClass, IncKVDictionaryRepresentable {}

public extension IncKVDictionaryInitableRepresentableClass {
   static var dictionaryKeys: [Key] { return Key.all }
}

