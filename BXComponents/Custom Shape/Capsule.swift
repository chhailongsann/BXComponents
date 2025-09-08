//
//  Capsule.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit

public class Capsule: UIView {
  
  
  // MARK: Properties
  private var fillColor: UIColor?
  private var strokeColor: UIColor?
  private var lineWidth: CGFloat = 0.4
  
  
  public func fill(_ color: UIColor) {
    fillColor = color
    setNeedsDisplay()
  }
  public func stroke(_ color: UIColor) {
    strokeColor = color
    setNeedsDisplay()
  }
  public func lineWidth(_ width: CGFloat) {
    lineWidth = width
    setNeedsDisplay()
  }
  
  // MARK: Life cycle
  
  // MARK: Init
  public init(fillColor: UIColor = .secondarySystemFill, strokeColor: UIColor = .separator, lineWidth: CGFloat = 0.4) {
    self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.lineWidth = lineWidth
    super.init(frame: .zero)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    let width = rect.width
    let height = rect.height
    
    let cornerRadius: CGFloat = min(width, height) / 2
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: cornerRadius, y: 0))
    path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi, clockwise: false)
    
    path.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: -CGFloat.pi, endAngle: -CGFloat.pi * 3/2, clockwise: false)
    
    path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: -CGFloat.pi * 3/2, endAngle: CGFloat.zero, clockwise: false)
    
    path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.zero, endAngle: -CGFloat.pi/2, clockwise: false)
    
    path.close()
    
    let borderLayer = CAShapeLayer()
    borderLayer.path = path.cgPath
    borderLayer.lineWidth = lineWidth
    borderLayer.strokeColor = strokeColor?.cgColor
    borderLayer.fillColor = fillColor?.cgColor
    borderLayer.frame = rect
    layer.insertSublayer(borderLayer, at: 0)
    
  }
}
