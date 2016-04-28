//
//  JDFoursquareViewController.swift
//  FoodFinder
//
//  Created by Devinci on 4/12/16.
//  Copyright © 2016 JDRichardsTech. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class JDFoursquareViewController: JDViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

	var fsquareTable: UITableView!
	var locationManager: CLLocationManager!
	var fsquareArray = Array<JDGoogleVenue>()
	
	
	
	 // MARK: - Lifecycles
	
	override func loadView() {
		super.loadView()
		
		//add view
		let frame = UIScreen.mainScreen().bounds
		let view = UIView(frame: frame)
		view.backgroundColor = UIColor.yellowColor()
		
		
		
		//add fsquare tableview
		self.fsquareTable = UITableView(frame:frame,style: .Plain)
		self.fsquareTable.delegate = self
		self.fsquareTable.dataSource = self
		self.fsquareTable.autoresizingMask = .FlexibleHeight
		view.addSubview(fsquareTable)
		
	
		self.view = view
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.locationManager = CLLocationManager()
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//---------------------
	
	//// MARK: - Datasource Delegate Functions
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		let count = self.fsquareArray.count
		print(count, "empty array")
		
		return count
	}
	
	func configureCell(cell: UITableViewCell, indexPath:NSIndexPath)->UITableViewCell{
		let venue = self.fsquareArray[indexPath.row]

		var details = venue.address
		
		if(venue.address.characters.count > 0 && venue.phone.characters.count>0){
			details = "\(venue.address), \(venue.phone)"
		}
		else{
			details = "\(venue.address)\(venue.phone)"
		}
		cell.textLabel?.text = venue.name
		
		
		cell.detailTextLabel?.text = details
		return cell
	}
	

	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
	
		
		let cellId = "cellId"
		
		if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
			print(self.configureCell(cell, indexPath: indexPath))
			return self.configureCell(cell, indexPath:indexPath)
		}
		
		let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
			print(self.configureCell(cell, indexPath: indexPath))
			return self.configureCell(cell, indexPath:indexPath)
	}
	
	// MARK: - TAbleView Delegate
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
		let venue = self.fsquareArray[indexPath.row]
		
		
		let mapVc = JDMapViewController()
		
		//both of these values are declared on the map venue controller
		mapVc.venue = venue //gives the mpa one venue
		mapVc.allVenues = self.fsquareArray //gives the map all of the venues
		
		
		//change page
		self.navigationController?.pushViewController(mapVc, animated: true)
		
		
		print("\(self.fsquareArray[indexPath.row].name), \(self.fsquareArray[indexPath.row].lat),\(self.fsquareArray[indexPath.row].lng)")
		

		}
	
	
	
	// MARK: - CLLocation Delegate
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
		if(status == .AuthorizedWhenInUse){
		//print("authorized when in use")
		self.locationManager.startUpdatingLocation()
		}
	
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		
		if(locations.count==0){
			//print("This sucks")
		}
		
		
		//get user location
		let loc = locations[0]
		
		//check timestamp in order to receive updated information
		let now = NSDate().timeIntervalSince1970
		let locationTime = loc.timestamp.timeIntervalSince1970
		let delta = now - locationTime
		
		if(delta>10){ //this means data is cached so...ignore
			return print("shit")
		}
		
		//print ("Now = \(now)")
		//print ("Location Time =\(locationTime)")
		//print("Delta: \(delta)")
		
		//location within 100 meters not good enough
		if(loc.horizontalAccuracy>100){ //location not accurate enough
			return print ("What the fuck")
		}

		self.locationManager.stopUpdatingLocation()
		
		
		let latLng = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
		//print("\(latLng)")
		
		//query the google places api
		let url = "https://api.foursquare.com/v2/venues/search?v=20140806&ll=\(latLng)&client_id=13JAXOOTC0DKR14NEFCAZ3J4PUEH30SYEXMLHLNROVY1TW1Y&client_secret=SC40GAAWXQDOT0KVSDJXXAK0SL4MTHY4LQJFQM0VIHUTVS3O"
		
		
		Alamofire.request(.GET, url, parameters: nil).responseJSON{response in
			if let JSON = response.result.value as? Dictionary<String, AnyObject>{
					print("\(JSON)")
			
				//now you parse the data
				
					
					if let resp = JSON["response"] as?Dictionary<String,AnyObject>{
					
					
						if let venues = resp["venues"] as? Array<Dictionary<String,AnyObject>>{
						
							for fsquareInfo in venues{
								
								let venue = JDGoogleVenue()
								venue.populate(fsquareInfo)
								self.fsquareArray.append(venue)
						}
					
						}
					
				
					
					
					
					
					self.fsquareTable.reloadData()
					
				}
			}
			
			//print("Found Current Location: \(loc.description)")
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
