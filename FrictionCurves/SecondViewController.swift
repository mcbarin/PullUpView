//
//  SecondViewController.swift
//  FrictionCurves
//
//  Created by Victor Baro on 3/5/15.
//  Copyright (c) 2015 Produkt. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController{

    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomView: UIView!
    
    var verticalLimit : CGFloat = 0.0
    var totalTranslation : CGFloat = 0.0
    
    var reverseVerticalLimit : CGFloat = 400
    var translation : CGFloat = 0.0
    let maxTranslationLimit : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
        self.verticalLimit = -screenHeight+100
        self.reverseVerticalLimit = -100
        
        totalTranslation = verticalLimit
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        // Swipe Gesture Declarations
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.bottomView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.bottomView.addGestureRecognizer(swipeUp)
        */
    }
    
    
    //  Swipe Gesture Recognizer handler
    func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                animateReverseLimit()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                animateViewBackToLimit()
            default:
                break
            }
        }
    }
    
    // For pan gesture recognizer
    @IBAction func viewDragged(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        // Down -> Positive, Up -> Negative
        totalTranslation += yTranslation
        self.translation += yTranslation // relative change
        if self.translation < 0 && self.translation < -maxTranslationLimit{
            if(sender.state == UIGestureRecognizerState.ended){
            animateViewBackToLimit()
            self.translation = 0
            }
        }else if (self.translation > 0 && self.translation > maxTranslationLimit){
            if(sender.state == UIGestureRecognizerState.ended){
            animateReverseLimit()
            self.translation = 0
            }
        }
        topViewConstraint.constant += yTranslation
//        if (topViewConstraint.hasExceeded(verticalLimit)){
//            totalTranslation += yTranslation
//            topViewConstraint.constant = logConstraintValueForYPosition(totalTranslation)
//            if(sender.state == UIGestureRecognizerState.ended ){
//                animateViewBackToLimit()
//            }
//        }else if(topViewConstraint.hasReversed(reverseVerticalLimit)){
//            totalTranslation -= yTranslation
//            topViewConstraint.constant = logConstraintValueForYPosition(totalTranslation)
//            if(sender.state == UIGestureRecognizerState.ended){
//                animateReverseLimit()
//            }
//        }else {
//            topViewConstraint.constant += yTranslation
//        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func logConstraintValueForYPosition(_ yPosition : CGFloat) -> CGFloat {
        return verticalLimit * (1 + log10(yPosition/verticalLimit))
    }
    func animateViewBackToLimit() {
        self.topViewConstraint.constant = self.verticalLimit
        
        // , usingSpringWithDamping: 0.2, initialSpringVelocity: 20 => Add this to animation for shaking it.
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10 ,options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = self.verticalLimit
            }, completion: nil)
    }
    
    func animateReverseLimit(){
        self.topViewConstraint.constant = self.reverseVerticalLimit
        
        UIView.animate(withDuration: 1, delay:0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = self.reverseVerticalLimit
        }, completion: nil)
    }
    
    
}

private extension NSLayoutConstraint {
    func hasExceeded(_ verticalLimit: CGFloat) -> Bool {
        return self.constant < verticalLimit
    }
    
    func hasReversed(_ reverseVerticalLimit: CGFloat) -> Bool {
        return self.constant > reverseVerticalLimit
    }
}

