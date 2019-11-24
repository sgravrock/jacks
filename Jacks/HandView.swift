import UIKit

protocol HandViewDelegate {
	func handView(_ handView: HandView, selectedPosition: Int)
}

// Should be 3.1x as wide as its height
class HandView: UIView {
	var delegate: HandViewDelegate?
	
	var enabled: Bool {
		didSet {
			for sv in subviews {
				(sv as! CardView).isEnabled = enabled
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.enabled = false
		super.init(coder: aDecoder)
		
		for i in 0..<4 {
			let cv = CardView(frame: CGRect.zero)
			cv.addTarget(self, action: #selector(HandView.cardTapped(_:)), for: UIControl.Event.touchUpInside)
			addSubview(cv) // will be laid out later
		}
	}
	
	override func layoutSubviews() {
		let cardWidth = bounds.height * 0.7
		let spacing = bounds.height * 0.1
		var x: CGFloat = 0.0
		
		for v in subviews {
			(v as UIView).frame = CGRect(x: x, y: 0, width: cardWidth, height: bounds.height)
			x += cardWidth + spacing
		}
	}
	
	func showHand(_ hand: [Card]) {
		for i in 0..<4 {
			showCard(card: hand[i], index: i)
		}
	}
	
	func showCard(card: Card, index i: Int) {
		(subviews[i] as! CardView).showCard(card)
	}
	
	func showCardAnimated(_ card: Card, atIndex i: Int, completion:  @escaping (() -> Void)) {
		(subviews[i] as! CardView).showCardAnimated(card, completion: completion)
	}
	
	func showBackAnimated(i: Int, completion:  @escaping (() -> Void)) {
		(subviews[i] as! CardView).showBackAnimated(completion)
	}
	
	func cardViewAtIndex(_ i: Int) -> CardView {
		return subviews[i] as! CardView
	}
	
	@objc func cardTapped(_ sender: CardView) {
		for i in 0..<4 {
			if subviews[i] === sender {
				delegate?.handView(self, selectedPosition: i)
				return
			}
		}
		
		assert(false, "HandView didn't find the selected card view")
	}
}
