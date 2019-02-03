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
    
    @IBOutlet weak var darkModeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitch.onTintColor = .orange
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "darkMode")
        refreshGUI()
    }
    
    
    
    //private functions
    private func refreshGUI() {
        let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        if darkMode {
            self.view.backgroundColor = .gray
            darkModeLabel.textColor = .white
        } else {
            self.view.backgroundColor = .white
            darkModeLabel.textColor = .black
        }
    }
    
    
    //outlet functions
    @IBAction func darkModeSwitchDidChange(_ sender: Any) {
        
        let isDarkModeOn = darkModeSwitch.isOn
        UserDefaults.standard.set(isDarkModeOn, forKey: "darkMode")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        refreshGUI()
        
    }
    
    
    
}
