import UIKit

class CardView: UIControl {
	let label = UILabel(frame: CGRectZero)
	let backView = UIControl(frame: CGRectZero)
	var card: Card? = nil
	
	override var enabled: Bool {
		didSet {
			layer.borderColor = (enabled ? UIColor.blueColor() : UIColor.blackColor()).CGColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		setup()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		label.frame = bounds
		backView.frame = bounds
		label.font = UIFont.systemFontOfSize(round(bounds.height * 0.36))
	}
	
	func showCard(cardToShow: Card) {
		card = cardToShow
		showSubview(label)
		label.text = "\(cardToShow.value)\n\(cardToShow.suit)"
	}
	
	func showBack() {
		card = nil
		backView.backgroundColor = UIColor.lightGrayColor()
		showSubview(backView)
	}
	
	func showNothing() {
		card = nil
		backView.backgroundColor = UIColor.clearColor()
		showSubview(backView)
	}
	
	func showCardAnimated(card: Card, completion:  (() -> Void)) {
		label.text = "\(card.value)\n\(card.suit)"

		UIView.transitionFromView(backView, toView: label, duration: 0.5,
			options: UIViewAnimationOptions.TransitionFlipFromLeft) { (completed) -> Void in
				completion()
		}
	}
	
	func showBackAnimated(completion:  (() -> Void)) {
		backView.backgroundColor = UIColor.lightGrayColor()
		UIView.transitionFromView(label, toView: backView, duration: 0.5,
			options: UIViewAnimationOptions.TransitionFlipFromLeft) { (completed) -> Void in
				completion()
		}
	}
		
	func cloneInView(destView: UIView) -> CardView {
		let cloneOrigin = self.convertPoint(self.bounds.origin, toView: destView)
		let cloneFrame = CGRectMake(cloneOrigin.x, cloneOrigin.y,
			self.bounds.size.width, self.bounds.size.height);
		let clone = CardView(frame: cloneFrame)
		destView.addSubview(clone)
		return clone
	}
	
	func subviewTapped() {
		sendActionsForControlEvents(UIControlEvents.TouchUpInside)
	}
	
	private func showSubview(subview: UIView) {
		if (subviews.count == 0) {
			addSubview(subview)
		} else if (subviews[0] as UIView != subview) {
			(subviews[0] as UIView).removeFromSuperview()
			addSubview(subview)
		}
	}
	
	private func setup() {
		self.enabled = false
		layer.borderWidth = 1.5
		layer.cornerRadius = 5
		label.textAlignment = NSTextAlignment.Center
		label.numberOfLines = 2
		label.backgroundColor = UIColor.whiteColor()
		backView.addTarget(self, action: "subviewTapped", forControlEvents: UIControlEvents.TouchUpInside)
		showBack()
	}
}
