//
//  StringBindable.swift
//  GigSalad
//
//  Created by Leif Meyer on 3/3/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public protocol IncKVStringComplianceClass: class, KVStringCompliance {}

public extension IncKVStringComplianceClass {
   func value(for key: String) -> Any? {
      let object = self as KVStringCompliance
      return object.value(for: key)
   }
   func set(value: Any?, for key: String) throws {
      var object = self as KVStringCompliance
      try object.set(value: value, for: key)
   }
}

public protocol BindingType {
   var key: String { get }
   var target: StringBindable { get }
   var targetKey: String { get }
}

public struct Binding {
   // MARK: - Public Properties
   public let key: String
   public let target: StringBindable
   public let targetKey: String
   
   public var targetValue: Any? { return target.value(for: key) }
   
   // MARK: - Public
   public func set(targetValue: Any?) throws {
      try target.set(value: targetValue, for: key)
   }
   
   // MARK: - Init
   public init<T: IncKVKeyType, U: IncKVKeyType>(key: T, target: StringBindable, targetKey: U) {
      self.key = key.rawValue
      self.target = target
      self.targetKey = targetKey.rawValue
   }
   
   public init(key: String, target: StringBindable, targetKey: String) {
      self.key = key
      self.target = target
      self.targetKey = targetKey
   }
}

extension Binding: BindingType {}

public protocol StringBindable: class, IncKVStringComplianceClass {
   func bind(key: String, to target: StringBindable, key targetKey: String) throws
   func bindOneWay(key: String, to target: StringBindable, key targetKey: String) throws
   func unbind(key: String, to target: StringBindable, key targetKey: String)
   func unbindOneWay(key: String, to target: StringBindable, key targetKey: String)
   func handleBindingError(_ error: Error, value: Any?, key: String)
}

public extension Bindable {
   func bind(_ binding: Binding) throws {
      try bind(key: binding.key, to: binding.target, key: binding.targetKey)
   }
   func bind(key: String, to target: StringBindable, key targetKey: String) throws {
      let kvKey = try Key(keyString: key)
      guard Self.bindableKeys.contains(kvKey) else { throw BindableError.invalidKey(name: kvKey.rawValue) }
      
      try target.bindOneWay(key: targetKey, to: self, key: key)
      
      _bindOneWay(kvKey: kvKey, to: target, key: targetKey)
   }
   func bindOneWay(key: String, to target: StringBindable, key targetKey: String) throws {
      let kvKey = try Key(keyString: key)
      guard Self.bindableKeys.contains(kvKey) else { throw BindableError.invalidKey(name: kvKey.rawValue) }
      
      try target.set(value: value(for: key), for: targetKey)
      
      _bindOneWay(kvKey: kvKey, to: target, key: targetKey)
   }
   func _bindOneWay(kvKey: Key, to target: StringBindable, key targetKey: String)  {
      let bindingBlock = { (match: (targetObject: AnyObject, rawTargetKey: String)?, value: Any?) -> Bool? in
         if let (matchTarget, matchRawTargetKey) = match { return matchTarget === target && matchRawTargetKey == targetKey}
         try target.set(value: value, for: targetKey)
         return nil
      }
      if var existingBindings = bindingBlocks[kvKey] {
         existingBindings.append(bindingBlock)
         bindingBlocks[kvKey] = existingBindings
      } else {
         bindingBlocks[kvKey] = [bindingBlock]
      }
   }
   func unbind(_ binding: Binding) {
      unbind(key: binding.key, to: binding.target, key: binding.targetKey)
   }
   func unbind(key: String, to target: StringBindable, key targetKey: String) {
      target.unbindOneWay(key: targetKey, to: self, key: key)
      unbindOneWay(key: key, to: target, key: targetKey)
   }
   func unbindOneWay(key: String, to target: StringBindable, key targetKey: String) {
      guard let kvKey = try? Key(keyString: key) else { return }
      let match = (targetObject: target as AnyObject, rawTargetKey: targetKey)
      bindingBlocks[kvKey] = bindingBlocks[kvKey]?.filter { !(try! $0(match, nil)!) }
   }
   func handleBindingError(_ error: Error, value: Any?, key: String) {
      guard let kvKey = try? Key(keyString: key) else { fatalError("String Binding error: Setting \(String(describing: value)) for \(key) threw \(error)") }
      handleBindingError(error, value: value, key: kvKey)
   }
   func targetBinding<Key: IncKVKeyType>(key: Key, targetKey: Self.Key) -> Binding {
      return Binding(key: key, target: self, targetKey: targetKey)
   }
}

public typealias BindingModel = [Binding]

public extension Array where Element: BindingType {
   func filter<Key: IncKVKeyType>(key: Key) -> [Binding] {
      let keyString: String = key.rawValue
      return flatMap {
         guard $0.key == keyString else { return nil }
         return $0 as? Binding
      }
   }
   func map<FirstKey: IncKVKeyType, SecondKey: IncKVKeyType>(firstKey first: FirstKey, toSecondKey second: SecondKey) -> [Binding] {
      return map {
         guard $0.key == first.rawValue else { return $0 as! Binding }
         return Binding(key: second.rawValue, target: $0.target, targetKey: $0.targetKey)
      }
   }
   func flatMap<FirstKey: IncKVKeyType, SecondKey: IncKVKeyType>(firstKey first: FirstKey, toSecondKey second: SecondKey) -> [Binding] {
      return flatMap {
         guard $0.key == first.rawValue else { return nil }
         return Binding(key: second.rawValue, target: $0.target, targetKey: $0.targetKey)
      }
   }
}

public extension Binding {
   func map<FirstKey: IncKVKeyType, SecondKey: IncKVKeyType>(firstKey first: FirstKey, toSecondKey second: SecondKey) -> Binding? {
      guard self.key == first.rawValue else { return nil }
      return Binding(key: second.rawValue, target: target, targetKey: targetKey)
   }
}
