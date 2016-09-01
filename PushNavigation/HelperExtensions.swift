//
//  HelperExtensions.swift
//  PsuhNot2
//
//  Created by development on 8/29/16.
//  Copyright © 2016 Tyro. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

public extension UINavigationController {
    public func pushViewController(viewController: UIViewController, animated: Bool, completion: () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

extension UIViewController {
    
    func centralButton(title title: String) -> UIButton {
        let b = UIButton(type: .System)
        b.backgroundColor = .blueColor()
        b.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        b.setTitle(title, forState: .Normal)
        b.frame = CGRectOffset(b.frame, self.view.frame.size.width / 2 - b.frame.width / 2, self.view.frame.size.height / 2 - b.frame.height)
        b.layer.cornerRadius = 5
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return b
    }
    
    func addNavRequest(){
        let t = UITextField()
        t.accessibilityLabel = "navTextField"
        let b = self.centralButton(title: "Go")
        
        b.action { _ in
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "remoteNotification", object: nil, userInfo: ["target":t.text ?? ""]))
        }
        
        t.frame = CGRectOffset(b.frame, 0, 60)
        t.backgroundColor = UIColor.lightGrayColor()
        
        self.view.addSubview(b)
        self.view.addSubview(t)
    }
    
    func buildView(){
        self.title = (self as? Node)?.name()
        self.view.backgroundColor = UIColor.whiteColor()
        addNavRequest()
    }
}

typealias BlockButtonActionBlock = (sender: UIButton) -> Void

class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: BlockButtonActionBlock) {
        self.block = block
    }
}

extension UIButton {
    func action(block: BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender: sender)
    }
}



