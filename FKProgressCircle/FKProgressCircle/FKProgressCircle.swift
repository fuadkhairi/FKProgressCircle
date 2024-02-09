//
//  FKProgrssCircle.swift
//  FKProgressCircle
//
//  Created by Fuad Khairi Hamid on 09/02/24.
//

import Foundation
import UIKit

public class FKProgressCircle: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var tracklayer = CAShapeLayer()
    fileprivate var progressArrow = CALayer()
    fileprivate var orbit = CAKeyframeAnimation(keyPath: "position")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    public var progressColor:UIColor = UIColor.green {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    public var trackColor:UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = trackColor.cgColor
        }
    }
    
    public var arrowImage: UIImage? = UIImage(systemName: "arrow.right")?.withTintColor(.white) {
        didSet {
            progressArrow.contents = arrowImage?.cgImage
        }
    }
    
    public var duration: TimeInterval = 2.0
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        tracklayer.path = circlePath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = trackColor.cgColor
        tracklayer.lineWidth = 2.0;
        tracklayer.strokeEnd = 1.0
        layer.addSublayer(tracklayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 18.0;
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = .round
        
        layer.addSublayer(progressLayer)
        progressArrow.contents = arrowImage?.cgImage
        progressArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        progressArrow.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        progressLayer.addSublayer(progressArrow)
    }
    
    public func setProgressValue(value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = value == 0 ? 0 : CGFloat(value)
        progressLayer.add(animation, forKey: "animateCircle")
        
        let startAngle = CGFloat(-0.5 * Double.pi)
        let endAngle = startAngle + (2 * .pi * CGFloat(value))
        let progressPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi),
                                        endAngle: endAngle-0.05, clockwise: true)
        orbit.path = progressPath.cgPath
        orbit.duration = duration
        orbit.repeatCount = 0
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = .forwards
        progressArrow.add(orbit, forKey: "movingMeterTip")
        
        if value >= 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.progressArrow.removeFromSuperlayer()
            }
        } else if value == 0.0 {
            let circleLayer = CAShapeLayer()
            circleLayer.anchorPoint = CGPoint(x: 0.8, y: 0.8)
            circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 18, height: 18)).cgPath
            circleLayer.fillColor = progressColor.cgColor
            circleLayer.strokeColor = progressColor.cgColor
            progressLayer.insertSublayer(circleLayer, at: 0)
            circleLayer.frame = progressArrow.bounds
            circleLayer.add(orbit, forKey: "movingMeterTip")
        }
    }
    
}
