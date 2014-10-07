//
//  SettingsViewController.swift
//  99RedBalloons
//
//  Created by Macbook Pro Video on 06/10/14.
//  Copyright (c) 2014 Victor Mart. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate
{
    func restartGameWithNewSettings(numberOfBalloons:Int)
}

class SettingsViewController: UIViewController {

    //MARK: Variables & Outlets
    @IBOutlet weak var initialNumberOfBalloonsSlider: UISlider!
    @IBOutlet weak var numberOfBalloonsLabel: UILabel!
    var numberOfBalloons:Int!
    
    var delegate:SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialNumberOfBalloonsSlider.value = 10.0
        self.initialNumberOfBalloonsSlider.maximumValue = 99.0
        self.initialNumberOfBalloonsSlider.minimumValue = 4.0
        self.numberOfBalloonsLabel.text = "\(Int(self.initialNumberOfBalloonsSlider.value))"
        
        self.initialNumberOfBalloonsSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    // MARK: ViewController Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func cancelButtonPressed(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton)
    {
        self.delegate?.restartGameWithNewSettings(self.numberOfBalloons)
    }
    
    // MARK: UISlider Delegate
    func sliderValueChanged(sender: UISlider)
    {
        self.numberOfBalloonsLabel.text = "\(Int(self.initialNumberOfBalloonsSlider.value))"
        self.numberOfBalloons = Int(self.initialNumberOfBalloonsSlider.value)
    }

}
