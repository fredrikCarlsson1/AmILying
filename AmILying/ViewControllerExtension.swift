//
//  ViewControllerExtension.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

extension UIViewController {    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIButton {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension UIView {
    func shakeView() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        rotation.duration = 0.08
        rotation.repeatCount = 3
        
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.04)
        rotation.toValue = NSNumber(value: -0.04)
        rotation.autoreverses = true
        layer.add(rotation, forKey: "rotate")
        
    }
    func shakeViewSlowly() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        rotation.duration = 1
        rotation.repeatCount = 1000
        
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.07)
        rotation.toValue = NSNumber(value: -0.07)
        rotation.autoreverses = true
        layer.add(rotation, forKey: "rotate")
        
    }
    
    
    func roundCorner(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        
    }
    
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.95
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 20
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
        
    }
    
    
    func pulsateStar(){
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.6
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        
        layer.add(animationGroup, forKey: "pulse")
        
    }
    
    
    func blink(delay: CFTimeInterval = 0.0 ) {
        self.alpha = 1

        UIView.animate(withDuration: 0.7, delay: delay, options: [.allowUserInteraction, .autoreverse], animations: {
            self.alpha = 0
        }) { (true) in
            self.blink(delay: delay)
        }

    }
    
    
    
}
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}







