//
//  JSONTests.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/27/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import XCTest
import Bindable

class JSONTests: XCTestCase {
   var eventJSON: [String : Any]!
   
   override func setUp() {
      eventJSON = [
         "category": "category2",
         "venueNameOrAddress": "The bit",
         "venueLegalAddress": "2048 Broadway",
         ]
   }
   
   func testJSONInitable() throws {
      do {
         let event = try JSONEvent(json: eventJSON)
         XCTAssertNotNil(event)

         XCTAssertEqual(event?.category.rawValue, (eventJSON["category"] as! String))
         XCTAssertNil(event?.type)
         XCTAssertEqual(event?.venueNameOrAddress, (eventJSON["venueNameOrAddress"] as! String))
         XCTAssertEqual(event?.venueLegalAddress, (eventJSON["venueLegalAddress"] as! String))
      }
      catch { XCTFail("Error: \(error)") }
   }

   func testJSONRepresentable() throws {
      let event = JSONEvent()
      event.category = KVEventCategory(rawValue: eventJSON[KVEventKey.category.rawValue] as! String)!
      event.type = nil
      event.venueNameOrAddress = eventJSON[KVEventKey.venueNameOrAddress.rawValue] as! String
      event.venueLegalAddress = (eventJSON[KVEventKey.venueLegalAddress.rawValue] as! String)
      
      let jsonRepresentation = event.jsonRepresentation
      XCTAssertNotNil(jsonRepresentation)
      
      let jsonObject = jsonRepresentation as? [String : String]
      XCTAssertNotNil(jsonObject)
      
      XCTAssertEqual(jsonObject ?? [:], eventJSON as! [String : String])
   }

}
