//
//  Bindable.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/23/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public enum BindableError: Error {
   case invalidKey(name: String)
}

public protocol Bindable: IncKVCompliance, StringBindable {
   static var bindableKeys: [Key] { get }

   var bindingBlocks: [Key : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] { get set }
   var keysBeingSet: [Key] { get set }
   
   func bind<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) throws
   func bindOneWay<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) throws
   func unbind<T: Bindable>(key: Key, to target: T, key targetKey: T.Key)
   func unbindOneWay<T: Bindable>(key: Key, to target: T, key targetKey: T.Key)
   func setBoundValue(_ value: Any?, for key: Key) throws
   func setOwn(value: Any?, for key: Key) throws
   func handleBindingError(_ error: Error, value: Any?, key: Key)
}

public extension Bindable {
   static var bindableKeys: [Key] { return Key.all }

   func bind<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) throws {
      guard Self.bindableKeys.contains(key) else { throw BindableError.invalidKey(name: key.rawValue) }
      try target.bindOneWay(key: targetKey, to: self, key: key)
      _bindOneWay(key: key, to: target, key: targetKey)
   }
   
   func bindOneWay<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) throws {
      guard Self.bindableKeys.contains(key) else { throw BindableError.invalidKey(name: key.rawValue) }
      try target.set(value: value(for: key), for: targetKey)
      _bindOneWay(key: key, to: target, key: targetKey)
   }
   
   func _bindOneWay<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) {
      let bindingBlock = { (match: (targetObject: AnyObject, rawTargetKey: String)?, value: Any?) -> Bool? in
         if let (matchTarget, matchRawTargetKey) = match { return matchTarget === target && matchRawTargetKey == targetKey.rawValue}
         try target.set(value: value, for: targetKey)
         return nil
      }
      if var existingBindings = bindingBlocks[key] {
         existingBindings.append(bindingBlock)
         bindingBlocks[key] = existingBindings
      } else {
         bindingBlocks[key] = [bindingBlock]
      }
   }
   
   func unbind<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) {
      target.unbindOneWay(key: targetKey, to: self, key: key)
      unbindOneWay(key: key, to: target, key: targetKey)
   }
   
   func unbindOneWay<T: Bindable>(key: Key, to target: T, key targetKey: T.Key) {
      let match = (targetObject: target as AnyObject, rawTargetKey: targetKey.rawValue)
      bindingBlocks[key] = bindingBlocks[key]?.filter { !(try! $0(match, nil)!) }
   }
   
   func setBoundValue(_ value: Any?, for key: Key) throws {
      guard !keysBeingSet.contains(key) else { return }
      keysBeingSet.append(key)
      defer { finishedSetting(bindableKey: key) }
      guard let bindings = bindingBlocks[key] else { return }
      try bindings.forEach { let _ = try $0(nil, value) }
   }
   
   func shouldSet(bindableKey: Key) -> Bool {
      return !keysBeingSet.contains(bindableKey)
   }
   
   func finishedSetting(bindableKey: Key) {
      if bindableKey == keysBeingSet.first { keysBeingSet = [] }
   }
   
   func handleBindingError(_ error: Error, value: Any?, key: Key) { fatalError("Binding error: Setting \(String(describing: value)) for \(key) threw \(error)") }
   
   func set(value: Any?, for key: Key) throws {
      try setAsBindable(value: value, for: key)
   }
   
   func setAsBindable(value: Any?, for key: Key) throws {
      guard Self.bindableKeys.contains(key) else { try setOwn(value: value, for: key); return }
      guard shouldSet(bindableKey: key) else { return }
      try setOwn(value: value, for: key)
      try setBoundValue(value, for: key)
   }
   
   public func trySetBoundValue(_ value: Any?, for key: Key) {
      do { try setBoundValue(value, for: key) }
      catch { handleBindingError(error, value: value, key: key) }
   }
   
   func value(for key: String) -> Any? {
      guard let key = try? Key(keyString: key) else { return nil }
      return value(for: key)
   }
   
   func set(value: Any?, for key: String) throws {
      let key = try Key(keyString: key)
      try set(value: value, for: key)
   }
}

public func IncIterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
   var i = 0
   return AnyIterator {
      let next = withUnsafePointer(to: &i) {
         $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
      }
      if next.hashValue != i { return nil }
      i += 1
      return next
   }
}
