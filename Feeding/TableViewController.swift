//
//  TableViewController.swift
//  Feeding
//
//  Created by 이영록 on 2017. 10. 28..
//  Copyright © 2017년 jellyworks. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
	//let key = "qzlVqmGoLRO5ZJQkCQJoOSAUWMmoWvgxArZ6e5Mw6OXQ7CkfUuiSKVb3t89PfI1oBtbJnWlho2N73nn66aID6g%3D%3D"
    
    let key = "aT2qqrDmCzPVVXR6EFs6I50LZTIvvDrlvDKekAv9ltv9dbO%2F8i8JBz2wsrkpr9yrPEODkcXYzAqAEX1m%2Fl4nHQ%3D%3D"
	let listEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
	let detailEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
	
	var parser:XMLParser!
	var item:[String:String] = [:]
	var items:[[String:String]] = []
	var detailItems:NSMutableArray = []
	
	var currentElement:String = ""
	var beforeElement:String = ""
	var url:URL?

    override func viewDidLoad() {
        super.viewDidLoad()

		// 파싱한 공공데이터를 아이폰 내에 Feeding.plist에 넣기 위한 작업
        let fileManager = FileManager.default
		url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Feeding.plist")
		print(url!.path)
		
        // 최초 실행 때는 공공데이터 파싱을 하고 그 데이터를 저장하며, 다음번 부터는 로컬에 있는 파싱한 데이터를 사용하여 속도가 빨라짐
        if fileManager.fileExists(atPath: url!.path) {
			detailItems = NSArray(contentsOf: url!) as! NSMutableArray
		} else {
			getList()
			let listItems = items
			for item in listItems {
				getDetail(idx: item["idx"]!)
				if let detailItem = items.first {
					detailItems.add(detailItem)
				}
			}
			detailItems.write(to: url!, atomically: true)
		}
		
		print(url!)
		print(detailItems.count)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailItems.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
		let dic = detailItems[indexPath.row] as! NSDictionary
		print(dic["name"]!)
		
		let lblName = cell.viewWithTag(1) as? UILabel
		lblName!.text = dic["name"]! as? String
		
		let lblDays = cell.viewWithTag(2) as? UILabel
		lblDays!.text = dic["mealDay"]! as? String
       return cell
    }
	

	func getList(){
		let strURL:String=listEndPoint + "?ServiceKey=\(key)&numOfRows=20"
		let url: URL = URL(string: strURL)!
		// Parse the XML
		parser = XMLParser(contentsOf: url)!
		parser.delegate = self
		
		let success:Bool = parser.parse()
		
		if success {
			print("parse success!")
			//			print(items)
		} else {
			print("parse failure!")
		}
	}
	
	func getDetail(idx:String){
		let strURL:String=detailEndPoint + "?ServiceKey=\(key)&idx=\(idx)"
		let url: URL = URL(string: strURL)!
		// Parse the XML
		parser = XMLParser(contentsOf: url)!
		parser.delegate = self
		
		let success:Bool = parser.parse()
		
		if success {
			print("parse success!")
			print(items)
		} else {
			print("parse failure!")
		}
		
	}


	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
		
		currentElement = elementName
		print(elementName)
		switch elementName {
		case "items":
			items = []
		case "item":
			item = [:]
			beforeElement = "item"
		default:
			break
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if(beforeElement=="item") {
			//			print("BeforeElement : \(beforeElement)  Element: \(currentElement)  String : \(string)")
			if(item[currentElement] == nil && currentElement != "item") {
				item[currentElement] = string.trimmingCharacters(in: CharacterSet.whitespaces)
			}
		}
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if(elementName == "item") {
			items.append(item)
			beforeElement = ""
		}
	}
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let indexPath = tableView.indexPathForSelectedRow
		let dic = detailItems[indexPath!.row] as? NSDictionary
		let detailViewController = segue.destination as? ViewController
		detailViewController?.item = dic
		
    }
}
