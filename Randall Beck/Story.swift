//
//  Story.swift
//  Randall Beck
//
//  Created by Randall Beck on 4/17/15.
//  Copyright © 2015 Ch1pa Software. All rights reserved.
//

import Foundation
import UIKit

 let attributedStringParagraphStyle = NSMutableParagraphStyle()


@objc class Story : UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    class func myStringA() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        return NSAttributedString(string: "Hi, my name is Randall, but I go by Chip. As you can see I’m a little busy dodging eagles and jaguars! Get me a little farther and I’ll tell you more about me…", attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSFontAttributeName:UIFont(name:"AvenirNext-Regular", size:18.0)!])
        
    }
    class func myStringB() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        return NSAttributedString(string: "I’ve been developing apps for nearly five years now, I started at 13 and now have published a total of 18 apps, transferring three to fellow developers…", attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSFontAttributeName:UIFont(name:"AvenirNext-Regular", size:18.0)!])
        
    }
    class func myStringC() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        let attributedStringC = NSMutableAttributedString(string: "At 15 I wrote iOS App Development for Teens by Teens in order to get other teens interested in app development, I received the funds through Kickstarter and published the book on March 22, 2014…")
        
        attributedStringC.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Regular", size:18.0)!, range:NSMakeRange(0,14))
        attributedStringC.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Italic", size:18.0)!, range:NSMakeRange(14,38))
        attributedStringC.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Regular", size:18.0)!, range:NSMakeRange(52,142))
        attributedStringC.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,194))
        attributedStringC.addAttribute(NSForegroundColorAttributeName, value:UIColor.blackColor(), range:NSMakeRange(0,194))
        
        return attributedStringC
        
    }
    class func myStringD() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        return NSAttributedString(string: "Using my book I led a class of 20 who learned both the basics of programming and Objective-C over the course of a week…", attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSFontAttributeName:UIFont(name:"AvenirNext-Regular", size:18.0)!])
        
    }
    
    class func myStringE() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        return NSAttributedString(string: "In February 2015 I attended the Yahoo Mobile Developer Conference, meeting some cool developers whom I also met at WWDC 2015! At Dub Dub I also formed a symbiotic bond with many other students that I wouldn't trade for the world.", attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSFontAttributeName:UIFont(name:"AvenirNext-Regular", size:18.0)!])
        
    }
    
    class func myStringF() -> NSAttributedString {
        
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        
        let attributedString = NSMutableAttributedString(string: "Dub Dub 2015 inspired me to write Politica to track the 2016 presidential election, along with the 2nd edition of my book, iOS App Development for Teens by Teens, which is slated to release later this Summer! I hope to experience Dub Dub again this year!")
        
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Regular", size:16.0)!, range:NSMakeRange(0,34))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Italic", size:16.0)!, range:NSMakeRange(34,8))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Regular", size:16.0)!, range:NSMakeRange(42,81))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Italic", size:16.0)!, range:NSMakeRange(123,38))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNext-Regular", size:16.0)!, range:NSMakeRange(161,78))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.blackColor(), range:NSMakeRange(0,239))
        
        return attributedString
        
    }

    
        
}

