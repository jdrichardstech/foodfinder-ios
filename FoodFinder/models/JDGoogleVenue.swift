//
//  JDGoogleVenue.swift
//  FoodFinder
//
//  Created by Devinci on 4/12/16.
//  Copyright © 2016 JDRichardsTech. All rights reserved.
//

import UIKit
import MapKit

class JDGoogleVenue: NSObject, MKAnnotation {

	var name: String!
	var address=""
	var rating: Float!
	var url: String!
	var phone=""
	var lng: Double!
	var lat: Double!
	
	//MARK: - required protocol methods for MKAnnotation(Map):
	// this info below lets the computer know where to put the pin
	//these lines btw are overrides
	var title: String?{
		return self.name
	}
	
	var subtitle: String?{
		return self.address
	}
	
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2DMake(self.lat, self.lng)
	}
	
	//this function is for populating table view cell
	func populate(info: Dictionary<String,AnyObject>){
		if let n = info["name"] as? String {
			self.name = n
		}
		if let a = info["vicinity"] as? String {
			self.address = a
		}
		if let r = info["rating"] as? Float {
			self.rating = r
		}
		if let u = info["url"] as? String {
			self.url = u
		}
		if let location = info["location"] as? Dictionary<String,AnyObject>{
			//print("location: \(location)")
			if let addr = location["address"] as? String{
				self.address = addr
			}
			if let lat = location["lat"] as? Double{
				self.lat = lat
			}
			if let lng = location["lng"] as? Double{
				self.lng = lng
			}
		}
		if let contact = info["contact"] as? Dictionary<String,AnyObject>{
			if let formattedPhone = contact["formattedPhone"] as? String{
				self.phone = formattedPhone
				
				
			}
		}
		
	}
	
	
}
