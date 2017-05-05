//
//  BindableTests.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/27/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import XCTest

class BindableTests: XCTestCase {
   
   
   func testOneWayBinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let finalAddress = "512 Broadway"
      
      try event1.set(value: initialAddress, for: .venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event1.bindOneWay(key: KVEventKey.venueNameOrAddress, to: event2, key: KVEventKey.venueLegalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event1.set(value: finalAddress, for: .venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
   }
   
   func testOneWayUnbinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let finalAddress = "512 Broadway"

      try event1.set(value: initialAddress, for: .venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      try event1.bindOneWay(key: KVEventKey.venueNameOrAddress, to: event2, key: KVEventKey.venueLegalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event1.unbindOneWay(key: KVEventKey.venueNameOrAddress, to: event2, key: KVEventKey.venueLegalAddress)
      try event1.set(value: finalAddress, for: .venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event2.venueLegalAddress, initialAddress)
   }
   
   func testBinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let midAddress = "1024 Broadway"
      let finalAddress = "512 Broadway"
      
      event1.venueNameOrAddress = initialAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event2.bind(key: KVEventKey.venueLegalAddress, to: event1, key: KVEventKey.venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)

      event2.venueLegalAddress = midAddress
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event1.venueNameOrAddress = finalAddress
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
   }

   func testUnbinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let midAddress = "1024 Broadway"
      let finalAddress = "512 Broadway"
      
      event1.venueNameOrAddress = initialAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event2.bind(key: KVEventKey.venueLegalAddress, to: event1, key: KVEventKey.venueNameOrAddress)
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event2.unbind(key: KVEventKey.venueLegalAddress, to: event1, key: KVEventKey.venueNameOrAddress)
      
      event2.venueLegalAddress = midAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
      
      event1.venueNameOrAddress = finalAddress
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
   }
   
   func testOneWayStringBinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let finalAddress = "512 Broadway"
      
      try event1.set(value: initialAddress, for: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event1.bindOneWay(key: "venueNameOrAddress", to: event2, key: "venueLegalAddress")
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event1.set(value: finalAddress, for: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
   }
   
   func testOneWayStringUnbinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let finalAddress = "512 Broadway"
      
      try event1.set(value: initialAddress, for: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      try event1.bindOneWay(key: "venueNameOrAddress", to: event2, key: "venueLegalAddress")
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event1.unbindOneWay(key: "venueNameOrAddress", to: event2, key: "venueLegalAddress")
      try event1.set(value: finalAddress, for: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event2.venueLegalAddress, initialAddress)
   }
   
   func testStringBinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let midAddress = "1024 Broadway"
      let finalAddress = "512 Broadway"
      
      event1.venueNameOrAddress = initialAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event2.bind(key: "venueLegalAddress", to: event1, key: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event2.venueLegalAddress = midAddress
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event1.venueNameOrAddress = finalAddress
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
   }
   
   func testStringUnbinding() throws {
      let event1 = BindableEvent()
      let event2 = BindableEvent()
      
      let initialAddress = "256 Broadway"
      let midAddress = "1024 Broadway"
      let finalAddress = "512 Broadway"
      
      event1.venueNameOrAddress = initialAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertNotEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      try event2.bind(key: "venueLegalAddress", to: event1, key: "venueNameOrAddress")
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event1.venueNameOrAddress, event2.venueLegalAddress)
      
      event2.unbind(key: "venueLegalAddress", to: event1, key: "venueNameOrAddress")
      
      event2.venueLegalAddress = midAddress
      XCTAssertEqual(event1.venueNameOrAddress, initialAddress)
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
      
      event1.venueNameOrAddress = finalAddress
      XCTAssertEqual(event1.venueNameOrAddress, finalAddress)
      XCTAssertEqual(event2.venueLegalAddress, midAddress)
   }
   
}
