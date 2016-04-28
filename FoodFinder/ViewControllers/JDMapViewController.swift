//
//  JDMapViewController.swift
//  FoodFinder
//
//  Created by Devinci on 4/13/16.
//  Copyright © 2016 JDRichardsTech. All rights reserved.
//

import UIKit
import MapKit

class JDMapViewController: JDViewController, MKMapViewDelegate {

	var venue: JDGoogleVenue!
	var mapView: MKMapView!
	var allVenues:Array<JDGoogleVenue>!
	
	override func loadView() {
		super.loadView()
		
		let frame = UIScreen.mainScreen().bounds
		let view = UIView(frame: frame)
		view.backgroundColor = UIColor.yellowColor()
		self.title = self.venue.name
		
		//creating the map
		self.mapView = MKMapView(frame:frame)
		let center = CLLocationCoordinate2DMake(self.venue.lat, self.venue.lng)
		self.mapView.centerCoordinate = center
		
		// define region
		let regionRadius:CLLocationDistance = 100
		
		let coordinateregion = MKCoordinateRegionMakeWithDistance(center,regionRadius, regionRadius)
		
		self.mapView.setRegion(coordinateregion, animated: true)
		
		//show the user's location
		self.mapView.showsUserLocation = true
		
		//add delegation
		self.mapView.delegate = self
		
		//show satelite view
		//self.mapView.mapType = .Satellite
		
		//this adds the delegate function below for map
	//for one pin this code	//self.mapView.addAnnotation(self.venue)
		self.mapView.addAnnotations(self.allVenues) //for all the pins

		
		view.addSubview(self.mapView)
		
		
		
		self.view = view
		
		
	}
	
	
	
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - MKMapView Delegate
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
		//return nil //just for now so code doesnt break
		if let annotation = annotation as? JDGoogleVenue {
			let identifier = "pin"
			
			// this is like defining the cell of a table
			if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as?
				MKPinAnnotationView{
				dequeuedView.annotation = annotation
				dequeuedView.canShowCallout = true
				return dequeuedView
				
			}
		
		
		
		}
		return nil
		
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
