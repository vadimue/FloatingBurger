import Foundation
import UIKit

@IBDesignable
class FloatingView: UIView {

  var dancingLine: CAShapeLayer! = CAShapeLayer()

  let lineColor = UIColor.black.cgColor
  let lineWidth: CGFloat = 3.0

  var straightPercentage: CGFloat {
    return calculateStraightPercentage(bounds.size.height/2)
  }

  private func calculateStraightPercentage(_ circleRadius: CGFloat) -> CGFloat {
    let straightLenght = bounds.size.width - bounds.size.height/2
    let circleLength = 2 * .pi * circleRadius
    let totalLength = straightLenght + circleLength
    return straightLenght / totalLength
  }

  var strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
  var strokeStart = CABasicAnimation(keyPath: "strokeStart")

  override func didMoveToWindow() {
    super.didMoveToWindow()
    layer.addSublayer(dancingLine)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setupStartAnimation()
    setupEndAnimation()
    setupDancingLayer()
  }

  private func setupStartAnimation() {
    strokeStart.duration = 1
    strokeStart.fromValue = 0
    strokeStart.toValue = straightPercentage
    strokeStart.isRemovedOnCompletion = false
    strokeStart.fillMode = kCAFillModeBoth
    dancingLine.add(strokeStart, forKey: "strokeStart")
  }


  private func setupEndAnimation() {
    strokeEnd.duration = 1
    strokeEnd.fromValue = straightPercentage
    strokeEnd.toValue = 1
    strokeEnd.isRemovedOnCompletion = false
    strokeEnd.fillMode = kCAFillModeBoth
    dancingLine.add(strokeEnd, forKey: "strokeEnd")
  }

  private func setupDancingLayer() {
    dancingLine.speed = 0
    dancingLine.path = getLinePath()
    dancingLine.frame = bounds
    dancingLine.strokeColor = lineColor
    dancingLine.fillColor = UIColor.clear.cgColor
    dancingLine.lineWidth = lineWidth
    dancingLine.strokeStart = 0
    dancingLine.strokeEnd = straightPercentage
  }

  private func getLinePath() -> CGPath {

    let circleRadius = bounds.size.height/2
    let circleX = bounds.size.width - bounds.size.height/2
    let circleCenter = CGPoint(x: circleX, y: circleRadius)

    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: bounds.size.height))
    path.addLine(to: CGPoint(x: circleX, y: bounds.size.height))
    path.addArc(withCenter: circleCenter,
                radius: circleRadius,
                startAngle: degreeToRadian(degrees: 90),
                endAngle: degreeToRadian(degrees: 91),
                clockwise: false)

    return path.cgPath
  }


  private func degreeToRadian(degrees: Float) -> CGFloat {
    return CGFloat(.pi*degrees/180)
  }

  func animateTo(percents: Float) {
    dancingLine.speed = 0
    dancingLine.timeOffset = CFTimeInterval(percents)
  }

  func animateToEnd() {
    dancingLine.beginTime = CACurrentMediaTime()
    dancingLine.speed = 1
  }

  func animateToStart() {
    dancingLine.beginTime = CACurrentMediaTime()
    dancingLine.speed = -1
    let completeionSpeed = 1.0 - dancingLine.timeOffset
    let delay = (1.0 - completeionSpeed) - 0.05
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
      self.animateTo(percents: 0)
    }
  }
}


