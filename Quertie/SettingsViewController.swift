//
//  SettingsViewController.swift
//  Quertie
//
//  Created by Edward Theodor on 03/02/2019.
//  Copyright © 2019 Edward Theodor. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let darkMode = isDarkModeOn {
             darkModeSwitch.isOn = darkMode
        }
        
    }
    
    
    
    
    @IBAction func darkModeSwitchDidChange(_ sender: Any) {
        
        isDarkModeOn = darkModeSwitch.isOn
        
    }
    
    
    
}
