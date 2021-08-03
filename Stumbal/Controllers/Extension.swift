//
//  Extension.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import Foundation

extension UIView {

    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var gradient1: UIColor? {
        set {
            guard newValue != nil else { return }
            layer.backgroundColor = newValue!.cgColor
        }
        get {
            guard let color = layer.backgroundColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var gradient2: UIColor? {
        set {
            guard let gradientColor = newValue else { return }
            let gradient = CAGradientLayer()
            gradient.frame = layer.bounds
            gradient.colors = [layer.backgroundColor! ,gradientColor.cgColor]
            layer.backgroundColor = UIColor.clear.cgColor
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.locations = [0.0, 1.2]
            layer.setValue(gradient, forKey: "rx_GradientLayer")
            layer.addSublayer(gradient)
        }
        get {
            return UIColor.gradient2
        }
    }
}
public extension UIColor {
    
    class var gradient1 : UIColor { return #colorLiteral(red: 0.9333333333, green: 0.8549019608, blue: 0.3568627451, alpha: 1) } //FF2755
    class var gradient2 : UIColor { return #colorLiteral(red: 0.5882352941, green: 0.3843137255, blue: 0.1568627451, alpha: 1) } //F87E48
 
}

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight , .topRight],
            cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedButton1(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
            cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
extension UIButton {
    @IBInspectable var adjustFontSizeToWidth: Bool {
        get {
            return ((self.titleLabel?.adjustsFontSizeToFitWidth) != nil)
        }
        set {
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.adjustsFontSizeToFitWidth = newValue;
            self.titleLabel?.lineBreakMode = .byClipping;
            self.titleLabel?.baselineAdjustment = .alignCenters
        }
    }
}
