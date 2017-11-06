//
//  ViewController.swift
//  Feeding
//
//  Created by 이영록 on 2017. 10. 28..
//  Copyright © 2017년 jellyworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var item:NSDictionary?
	@IBOutlet weak var lblPhone: UILabel!
	
	@IBOutlet weak var lblAddr: UILabel!
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblDays: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		lblName.text = item!["name"]! as? String
		lblDays.text = item!["mealDay"]! as? String
		lblPhone.text = item!["phone"]! as? String
		lblAddr.text = item!["addrRoad"]! as? String
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

