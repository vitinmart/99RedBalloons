//
//  ViewController.swift
//  99RedBalloons
//
//  Created by Victor Martinez on 02/10/14.
//  Copyright (c) 2014 Victor Mart. All rights reserved.
//
//  Thanks to bitfountain.io

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate{
    
    // MARK: variables
    //outlets from storyboard
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var redBallonsLabel: UILabel!
    
    //variable to change the number of balloons in the label
    var numberOfBalloons:Int!
    
    //array containing the images that will be the subviews created
    var arrayOfBalloonViews:[UIImageView] = []
    
    //instance of the struct Balloon
    var myBalloons = Balloon()

    //variable containing the coordinates of the tap
    var tapLocation:CGPoint!
    
    //tap gesture recognizer
    var tapGestureRecognizer:UITapGestureRecognizer!
    
    // MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a gestureRecognizer when we tap the screen
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "callItWhenTap:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        //Setup the image of the background's view
        view.backgroundColor = UIColor(patternImage: UIImage(named: "BG.png"))
        
        //initialize the number of balloons and show them in the view
        self.resetGameAndStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.destinationViewController .isKindOfClass(SettingsViewController){
                var destinationVC = segue.destinationViewController as SettingsViewController
                destinationVC.delegate = self
                
            }
    }
    
    // MARK: IBActions

    @IBAction func ResetBarButtonItem(sender: UIBarButtonItem)
    {
        let alert:UIAlertController = UIAlertController(title: "Reiniciar", message: "¿Estas seguro?", preferredStyle: .Alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (action) -> Void in
            //alert.removeFromParentViewController()
        }
        let reiniciarAction:UIAlertAction = UIAlertAction(title: "Reiniciar", style: .Default) { (action) -> Void in
            self.resetGameAndStart()
        }
        alert.addAction(cancelAction)
        alert.addAction(reiniciarAction)

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func settingsBarButtonItem(sender: UIBarButtonItem)
    {
        performSegueWithIdentifier("homeToSettingsViewControllerSegue", sender: self)
    }
    
    // MARK: UITapGestureRecognizer Method
    func callItWhenTap(sender: UITapGestureRecognizer){

        self.tapLocation = sender.locationInView(self.view)
        
        removeBalloonFromView()
        redBallonsLabel.bringSubviewToFront(view)
        
        
    }
    
    // MARK: Helper Methods
    
    //Method that creates an array with all the balloons in random positions
    func createBalloonsRandomInArray()
    {
        for i in 1...numberOfBalloons{
            var randomX = CGFloat(arc4random_uniform(UInt32(self.view.bounds.width - 90.0)))
            var randomY = CGFloat(arc4random_uniform(UInt32(self.view.bounds.height - 90.0)))

            var balloonView = UIImageView(frame: CGRectMake(randomX, randomY, 45.0, 45.0))
            balloonView.image = self.myBalloons.image
        
            self.arrayOfBalloonViews.append(balloonView)
        }
    }
    
    //Method to display the ballons on the view and bring the label to the top of the hierachy
    func displayBalloonsOnScreen()
    {
        
        for ballon in self.arrayOfBalloonViews{
            self.view.addSubview(ballon)
        }
        
        self.view.bringSubviewToFront(redBallonsLabel)
    }
    
    //Method to remove balloons from view if the balloon is taped on it subview, and determines what balloon is on top
    //if there are more than one balloon in the same point
    func removeBalloonFromView()
    {
        if (arrayOfBalloonViews.count == 1){
            for subviews in self.view.subviews{
                if (subviews.tag != 1) {
                    subviews.removeFromSuperview()
                    if ( CGRectContainsPoint(subviews.frame, self.tapLocation)) {
                        self.arrayOfBalloonViews.removeLast()
                        self.updateRedBalloonLabel()
                        
                        let alert:UIAlertController = UIAlertController(title: "Enhorabuena", message: "Has explotado todos los globos", preferredStyle: .Alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "Reiniciar", style: .Default, handler: { (action) -> Void in
                            self.resetGameAndStart()
                        })
                        alert.addAction(alertAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            self.displayBalloonsOnScreen()
            
        }else{
            var indexBalloonController2 = false
            var indexOfObjectWeTapped2 = 0
            var indexOfObjectWeTapped1 = 0
            
            for balloonSubview in self.view.subviews{
                var indexOfObjectToAssign = 0
                var indexBalloonController1 = false
                if (balloonSubview.tag != 1){
                    balloonSubview.removeFromSuperview()
                    if ( CGRectContainsPoint(balloonSubview.frame, self.tapLocation)) {
                        for arrayOfViews in self.arrayOfBalloonViews{
                            if (balloonSubview.frame == arrayOfViews.frame){
                                if (!indexBalloonController2 && !indexBalloonController1){
                                    indexBalloonController2 = true
                                    indexOfObjectWeTapped2 = indexOfObjectToAssign
                                }else if (indexBalloonController2 && !indexBalloonController1){
                                    indexBalloonController1 = true
                                    indexOfObjectWeTapped1 = indexOfObjectToAssign
                                }else{
                                    self.arrayOfBalloonViews.removeAtIndex(indexOfObjectToAssign)
                                }
                            }else{
                                indexOfObjectToAssign += 1
                            }
                        }
                    }
                }
                
            }
            if (indexOfObjectWeTapped1 > indexOfObjectWeTapped2){
                self.arrayOfBalloonViews.removeAtIndex(indexOfObjectWeTapped1)
                self.updateRedBalloonLabel()
            }else if (indexOfObjectWeTapped2 > indexOfObjectWeTapped1){
                self.arrayOfBalloonViews.removeAtIndex(indexOfObjectWeTapped2)
                self.updateRedBalloonLabel()
                
            }else if (indexOfObjectWeTapped2 == 0 && indexBalloonController2){
                self.arrayOfBalloonViews.removeAtIndex(0)
                self.updateRedBalloonLabel()
            }
            displayBalloonsOnScreen()
        }
    
    }
    
    func updateRedBalloonLabel(){
        self.numberOfBalloons = self.numberOfBalloons - 1
        self.redBallonsLabel.text = "\(self.numberOfBalloons) Red Balloons"
    }

    /*
      Method to reset all the values and start again.
      If the array is empty we initialize the number of balloons, the random array of balloons,
      the label and display the balloons again on the screen.
      If the array is not empty and there are balloons on the view we remove all the items of the array
      and all the balloons from the view, then call again the function to start again.
    */
    func resetGameAndStart(){
        if(self.arrayOfBalloonViews.count == 0){
            self.numberOfBalloons = self.myBalloons.initialNumberOfBalloons
            self.redBallonsLabel.text = "\(self.numberOfBalloons) Red Balloons"
            self.createBalloonsRandomInArray()
            self.displayBalloonsOnScreen()
        }else{
            for arrayOfViews in 1...self.arrayOfBalloonViews.count{
                self.arrayOfBalloonViews.removeLast()
            }
            for subviews in self.view.subviews{
                if (subviews.tag != 1) {
                    subviews.removeFromSuperview()
                }
            }
            resetGameAndStart()
        }
    }
    
    // MARK: SettingsViewControllerDelegate
    
    func restartGameWithNewSettings(numberOfBalloons:Int)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.myBalloons.initialNumberOfBalloons = numberOfBalloons
        self.resetGameAndStart()
    }
    
}

