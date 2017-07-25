//
//  ViewController.swift
//  ActionSheet
//
//  Created by M Usman Saeed on 25/07/2017.
//  Copyright © 2017 MUS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnShowActionSheet(_ sender: Any) {
        
        let action = ActionSheet(frame: self.view.frame)
        action.items = ["Blueberry","Apple","Coconut"]
        action.images = ["Blueberry","Apple","Coconut"]
        action.selectedIndexPath = { indexPath in
            print("\(indexPath)")
        }
        action.showActionSheetWithTitle(title: "SELECT FRUIT", scrollEnable: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

