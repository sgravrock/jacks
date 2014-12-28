import UIKit

// Should be 3.1x as wide as its height
class HandView: UIView {
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<4 {
			addSubview(CardView(frame: CGRectZero)) // will be laid out later
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
}
