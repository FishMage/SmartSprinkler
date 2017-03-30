//
//  HistoryViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/29/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHistory()
        print("set row_0")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHistory(){
        let cell: UITableViewCell = {
            guard let cell = table.dequeueReusableCell(withIdentifier: "cell_0") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell_0")
            }
            return cell
        }()
       
        cell.textLabel?.text       = "Key"
        cell.detailTextLabel?.text = "Value"
        cell.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
