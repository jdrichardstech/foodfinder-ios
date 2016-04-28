//
//  JDViewController.swift
//  FoodFinder
//
//  Created by Devinci on 4/12/16.
//  Copyright © 2016 JDRichardsTech. All rights reserved.
//

import UIKit

class JDViewController: UIViewController {
	
	

	
	
	//Find out what this code is for
	required init? (coder aDecoder: NSCoder){
		super.init(coder:aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		//this will work now for every page
		self.edgesForExtendedLayout = .None
	}


	
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
