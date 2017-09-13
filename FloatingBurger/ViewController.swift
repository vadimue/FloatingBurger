import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var floatingView: FloatingView!
  @IBOutlet weak var textView: UITextView!
  let maxY: Float = 200.0
}

extension ViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = calculateFactor(from: scrollView.contentOffset)
    floatingView.animateTo(percents: offset)
  }

  private func calculateFactor(from offset: CGPoint) -> Float {
    let yOffset = min(maxY, max(0.0, Float(offset.y)))
    return Float(yOffset) / maxY
  }
}

