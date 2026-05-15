import UIKit
import AudioToolbox

final class WheelScrollView: UIView, UIScrollViewDelegate {

  private let scrollView = UIScrollView()
  private let contentView = WheelContentView()
  private let indicator = UIView()

  private let step: CGFloat = 12
  private let totalTicks = 100

  // Physics
  private var displayLink: CADisplayLink?
  private var velocity: CGFloat = 0
  private var lastTimestamp: CFTimeInterval = 0

  // Haptics
  private var lastTick: Int = 0
  private let generator = UIImpactFeedbackGenerator(style: .light)

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    generator.prepare()
    setup()
  }

  private func setup() {
    backgroundColor = .white
    contentView.backgroundColor = .white
    scrollView.delegate = self
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceVertical = false
    scrollView.bounces = false
    scrollView.decelerationRate = .fast
    addSubview(scrollView)

    scrollView.addSubview(contentView)

    indicator.backgroundColor = .systemRed
    indicator.isUserInteractionEnabled = false
    addSubview(indicator)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    scrollView.frame = bounds

    let inset = (bounds.width / 2)
    scrollView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

    let contentWidth = CGFloat(totalTicks) * step
    scrollView.contentSize = CGSize(width: contentWidth, height: bounds.height)
    contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: bounds.height)

    indicator.frame = CGRect(x: bounds.midX - 1, y: 0, width: 2, height: bounds.height)
  }

  // MARK: - Scroll Delegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    contentView.setNeedsDisplay()
    updateHaptics()
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    targetContentOffset.pointee = scrollView.contentOffset
    startCustomDeceleration(initialVelocity: velocity.x)
  }

  // MARK: - Physics

  private func startCustomDeceleration(initialVelocity: CGFloat) {
    velocity = initialVelocity * 1000

    displayLink?.invalidate()
    displayLink = CADisplayLink(target: self, selector: #selector(stepLoop))
    displayLink?.add(to: .main, forMode: .common)
  }

  @objc private func stepLoop(link: CADisplayLink) {
    if lastTimestamp == 0 {
      lastTimestamp = link.timestamp
      return
    }

    let dt = link.timestamp - lastTimestamp
    lastTimestamp = link.timestamp

    let deceleration: CGFloat = 0.95
    velocity *= pow(deceleration, CGFloat(dt * 60))

    applyMagnetism()

    if abs(velocity) < 5 {
      snapToNearestTick()
      stop()
      return
    }

    let dx = velocity * CGFloat(dt)
    scrollView.contentOffset.x += dx
  }

  private func applyMagnetism() {
    let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
    let nearest = round(centerX / step) * step

    let distance = nearest - centerX
    let strength: CGFloat = 0.15
    velocity += distance * strength
  }

  private func snapToNearestTick() {
    let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
    let snapped = round(centerX / step) * step

    let targetOffset = snapped - scrollView.bounds.width / 2

    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
      self.scrollView.contentOffset.x = targetOffset
    }
  }

  private func stop() {
    displayLink?.invalidate()
    displayLink = nil
    lastTimestamp = 0
  }

  // MARK: - Haptics

  private func updateHaptics() {
    let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
    let tick = Int(round(centerX / step))

    if tick != lastTick {
      AudioServicesPlaySystemSound(1157)
      generator.impactOccurred(intensity: 0.6)
      generator.prepare()
      lastTick = tick
    }
  }
}

final class WheelContentView: UIView {

  var step: CGFloat = 12
//  var majorTickEvery: Int = 1

  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }

    let visibleMinX = rect.minX
    let visibleMaxX = rect.maxX

    let startIndex = Int(floor(visibleMinX / step))
    let endIndex   = Int(ceil(visibleMaxX / step))

    for i in startIndex...endIndex {
      let x = CGFloat(i) * step

//      let isMajor = i % majorTickEvery == 0
      let height: CGFloat = 40

      ctx.move(to: CGPoint(x: x, y: bounds.midY - height / 2))
      ctx.addLine(to: CGPoint(x: x, y: bounds.midY + height / 2))
    }

    ctx.setLineWidth(3)
    ctx.setLineCap(.round)
    ctx.setStrokeColor(UIColor.label.cgColor)
    ctx.strokePath()
  }
}
