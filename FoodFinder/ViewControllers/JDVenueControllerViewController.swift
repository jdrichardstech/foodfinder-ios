//
//  JDVenueViewController.swift
//  FoodFinder
//
//  Created by Devinci on 4/12/16.
//  Copyright © 2016 JDRichardsTech. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class JDVenueViewController: JDViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
	//MARK: - Properties
	
	var venuesTable: UITableView!
	var locationManager: CLLocationManager!
	//	var currentLocation: CLLocation!
	var venuesArray = Array<JDGoogleVenue>()
	
	
	
	
	//MARK: - Lifecycles
	
	override func loadView() {
		super.loadView()
		
		let frame = UIScreen.mainScreen().bounds
		let view = UIView(frame: frame)
		view.backgroundColor = UIColor.redColor()
		
		
		self.venuesTable = UITableView(frame: frame, style: .Plain)
		self.venuesTable.delegate = self
		self.venuesTable.dataSource = self
		self.venuesTable.autoresizingMask = .FlexibleHeight
		view.addSubview(venuesTable)
		
		
		self.view = view
	}
	
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.locationManager = CLLocationManager()
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.delegate = self
		
		
		
		
		
		//AIzaSyCxSusaCdp2Tz_SV_ceSDKSdhvLSTZ7UEI  my api key
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	//MARK: - Datsource Delegate Functions
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return self.venuesArray.count
	}
	
	func configureCell(cell: UITableViewCell, indexPath:NSIndexPath)->UITableViewCell{
		let venue = self.venuesArray[indexPath.row]
		cell.textLabel?.text =  venue.name
		cell.detailTextLabel?.text = venue.address //add rating when you have time
		return cell
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		let cellId = "cellId"
		
		if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
			return self.configureCell(cell, indexPath:indexPath)
		}
		
		let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
		return self.configureCell(cell, indexPath:indexPath)
		
		
	}
	
	//MARK: - Location Manager Delegate
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		//print("didUpdateLocations \(locations)")
		if(locations.count==0){
			return
		}
		
		
		//get user location
		let loc = locations[0]
		
		//check timestamp in order to receive updated information
		let now = NSDate().timeIntervalSince1970
		let locationTime = loc.timestamp.timeIntervalSince1970
		let delta = now - locationTime
		
		if(delta>10){ //this means data is cached so...ignore
			print("Fuckin delta")
			return
		}
		
		print ("Now = \(now)")
		print ("Location Time =\(locationTime)")
		print("Delta: \(delta)")
		
		//location within 100 meters not good enough
		if(loc.horizontalAccuracy>100){ //location not accurate enough
			return
		}
		
		
		
		//if location is accurate enough then stop updating location
		self.locationManager.stopUpdatingLocation()
		
		
		//for making dynamic requests
		let latLng = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
		
		//query the google places api
		let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLng)&radius=500&types=restaurant&key=AIzaSyCxSusaCdp2Tz_SV_ceSDKSdhvLSTZ7UEI"
		
		//api request
		Alamofire.request(.GET, url, parameters: nil).responseJSON{response in
			if let JSON = response.result.value as? Dictionary<String, AnyObject>{
				//			print("\(JSON)")
				
				//now you parse the data
				if let results = JSON["results"] as? Array<Dictionary<String,AnyObject>>{
					for venueInfo in results{
						
						let venue = JDGoogleVenue()
						venue.populate(venueInfo)
						self.venuesArray.append(venue)
					}
					self.venuesTable.reloadData()
				}
			}
			
			print("Found Current Location: \(loc.description)")
		}
		
	}
	
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
		if(status == .AuthorizedWhenInUse){//ie user says yes to using location
			print("Authorized When In Use")
			self.locationManager.startUpdatingLocation()
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
