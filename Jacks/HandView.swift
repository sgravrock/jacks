import UIKit

protocol HandViewDelegate {
	func handView(handView: HandView, selectedPosition: Int)
}

// Should be 3.1x as wide as its height
class HandView: UIView {
	var delegate: HandViewDelegate?
	
	var enabled: Bool {
		didSet {
			for sv in subviews {
				(sv as CardView).enabled = enabled
			}
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		self.enabled = false
		super.init(coder: aDecoder)
		
		for i in 0..<4 {
			let cv = CardView(frame: CGRectZero)
			cv.addTarget(self, action: "cardTapped:", forControlEvents: UIControlEvents.TouchUpInside)
			addSubview(cv) // will be laid out later
		}
	}
	
	override func layoutSubviews() {
		let cardWidth = bounds.height * 0.7
		let spacing = bounds.height * 0.1
		var x: CGFloat = 0.0
		
		for v in subviews {
			(v as UIView).frame = CGRectMake(x, 0, cardWidth, bounds.height)
			x += cardWidth + spacing
		}
	}
	
	func showHand(hand: [Card]) {
		for i in 0..<4 {
			showCard(card: hand[i], index: i)
		}
	}
	
	func showCard(#card: Card, index i: Int) {
		(subviews[i] as CardView).showCard(card)
	}
	
	func cardTapped(sender: CardView) {
		for i in 0..<4 {
			if subviews[i] === sender {
				delegate?.handView(self, selectedPosition: i)
				return
			}
		}
		
		assert(false, "HandView didn't find the selected card view")
	}
}
