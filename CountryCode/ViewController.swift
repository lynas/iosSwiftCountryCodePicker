//
//  ViewController.swift
//  CountryCode
//
//  Created by sazzad on 2/8/17.
//  Copyright © 2017 Dynamic Solution Innovators. All rights reserved.
//

import UIKit
import PhoneCountryCodePicker
import Gloss
import Alamofire
import RxAlamofire
import RxSwift

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var cnTableView: UITableView!
    
    var cnList = [CountryCode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var countryDic: [AnyHashable: Any] = PCCPViewController.info(forPhoneCode: 880) as! [AnyHashable : Any]
        let flag: UIImage? = PCCPViewController.image(forCountryCode: countryDic["country_code"] as! String!)
        //cc.image = flag!
        readJson()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cnList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.name.text = cnList[indexPath.row].name
        let dialCode = cnList[indexPath.row].dial_code
        cell.number.text = dialCode
        let codeStr = String(dialCode!.characters.dropFirst())
        let codeStrNoSpace = codeStr.removingWhitespaces()
        let code = Int("\(codeStrNoSpace)")
        if let countryDic: [AnyHashable: Any] = PCCPViewController.info(forPhoneCode: code!) as? [AnyHashable : Any] {
            if let cnImg = PCCPViewController.image(forCountryCode: countryDic["country_code"] as! String!) {
                cell.cnImage.image = cnImg
            }
        }
        
        return cell
    }
    
    func readJson () {
        if let data = loadJson(filename: "cd") {
            if let list = [CountryCode].from(jsonArray: data)  {
                /*for each in list {
                    print(each.name ?? "")
                    print(each.dial_code ?? "")
                    print(each.code ?? "")
                    print("###########")
                    print("###########")
                }*/
                self.cnList = list
                self.cnTableView.reloadData()
            }
        }
        
        
        
        
    }
    
    func loadJson(filename fileName: String) -> [JSON]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dictionary = object as? [[String: Any]] {
                        return dictionary
                    }
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
}



struct CountryCode : Decodable {
    
    let name: String?
    let dial_code: String?
    let code : String?
    
    init?(json: JSON) {
        self.name = "name" <~~ json
        self.dial_code = "dial_code" <~~ json
        self.code = "code" <~~ json
    }
}


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}












