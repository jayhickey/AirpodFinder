//
//  ProgressView.swift
//  AirpodFinder
//
//  Created by johnrhickey on 12/27/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import UIKit
import CoreGraphics

class ProgressView: UIView {
    
    private let emptyAngle = 130
    private let fullAngle = 410
    
    private var textLabel = UILabel()
    
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override var bounds: CGRect {
        didSet {
            self.updatePaths()
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.updatePaths()
        }
    }
    
    public func set(progress: CGFloat, animated: Bool) {
        self.update(progress: progress, animated: true)
    }
    
    public func set(label: String) {
        self.textLabel.text = label
        self.updateTextLayout()
    }
    
    // MARK: Private Properties
    
    private var circlePath: UIBezierPath {
        get {
            let insetRect = self.bounds.insetBy(dx: 6.0, dy: 6.0)
            let ovalPath = UIBezierPath(arcCenter: CGPoint(x: insetRect.midX, y: insetRect.midY), radius: insetRect.width / 2, startAngle: CGFloat(emptyAngle).toRad, endAngle: CGFloat(fullAngle).toRad, clockwise: true)
            return ovalPath
        }
    }
    
    private var progressPath: UIBezierPath {
        get {
            let insetRect = self.bounds.insetBy(dx: 3.0, dy: 3.0)
            let ovalPath = UIBezierPath(arcCenter: CGPoint(x: insetRect.midX, y: insetRect.midY), radius: insetRect.width / 2, startAngle: CGFloat(emptyAngle).toRad, endAngle: CGFloat(fullAngle).toRad, clockwise: true)
            return ovalPath
        }
    }
    
    // MARK: Private
    
    private func update(progress: CGFloat, animated: Bool) {
        let strokeEndKey = "strokeEnd"
        guard let currentRotation = self.progressLayer.presentation()?.value(forKeyPath: strokeEndKey) else {
            return
        }
        
        self.progressLayer.strokeEnd = progress
        
        if (animated) {
            let animation = CABasicAnimation(keyPath: strokeEndKey)
            animation.duration = 0.3
            animation.fromValue = currentRotation
            animation.toValue = progress
            animation.fillMode = kCAFillModeForwards
            self.progressLayer.add(animation, forKey: strokeEndKey)
        }
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
        
        progressLayer.strokeColor = UIColor.darkGray.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6.0
        self.layer.addSublayer(progressLayer)
        
        textLabel.font = UIFont.systemFont(ofSize: 36.0)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        
        self.updateTextLayout()
        self.updatePaths()
        self.update(progress: 0.0, animated: false)
    }
    
    private func updatePaths() {
        if (self.frame.isEmpty) {
            return
        }
        
        self.circleLayer.path = self.circlePath.cgPath
        self.progressLayer.path = self.progressPath.cgPath
    }
    
    private func updateTextLayout() {
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
