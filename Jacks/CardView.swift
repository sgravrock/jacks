import UIKit

class CardView: UIControl {
	let label = UILabel(frame: CGRect.zero)
	let backView = UIControl(frame: CGRect.zero)
	var card: Card? = nil
	
	override var isEnabled: Bool {
		didSet {
			layer.borderColor = (isEnabled ? UIColor.blue : UIColor.black).cgColor
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
		label.font = UIFont.systemFont(ofSize: round(bounds.height * 0.36))
	}
	
	func showCard(_ cardToShow: Card) {
		card = cardToShow
		showSubview(label)
		label.text = "\(cardToShow.value)\n\(cardToShow.suit)"
	}
	
	func showBack() {
		card = nil
		backView.backgroundColor = UIColor.lightGray
		showSubview(backView)
	}
	
	func showNothing() {
		card = nil
		backView.backgroundColor = UIColor.clear
		showSubview(backView)
	}
	
	func showCardAnimated(_ card: Card, completion:  @escaping (() -> Void)) {
		label.text = "\(card.value)\n\(card.suit)"

		UIView.transition(from: backView, to: label, duration: 0.5,
			options: UIViewAnimationOptions.transitionFlipFromLeft) { (completed) -> Void in
				completion()
		}
	}
	
	func showBackAnimated(_ completion:  @escaping (() -> Void)) {
		backView.backgroundColor = UIColor.lightGray
		UIView.transition(from: label, to: backView, duration: 0.5,
			options: UIViewAnimationOptions.transitionFlipFromLeft) { (completed) -> Void in
				completion()
		}
	}
		
	func cloneInView(_ destView: UIView) -> CardView {
		let cloneOrigin = self.convert(self.bounds.origin, to: destView)
		let cloneFrame = CGRect(x: cloneOrigin.x, y: cloneOrigin.y,
			width: self.bounds.size.width, height: self.bounds.size.height);
		let clone = CardView(frame: cloneFrame)
		destView.addSubview(clone)
		return clone
	}
	
	func subviewTapped() {
		sendActions(for: UIControlEvents.touchUpInside)
	}
	
	fileprivate func showSubview(_ subview: UIView) {
		if (subviews.count == 0) {
			addSubview(subview)
		} else if (subviews[0] as UIView != subview) {
			(subviews[0] as UIView).removeFromSuperview()
			addSubview(subview)
		}
	}
	
	fileprivate func setup() {
		self.isEnabled = false
		layer.borderWidth = 1.5
		layer.cornerRadius = 5
		label.textAlignment = NSTextAlignment.center
		label.numberOfLines = 2
		label.backgroundColor = UIColor.white
		backView.addTarget(self, action: #selector(CardView.subviewTapped), for: UIControlEvents.touchUpInside)
		showBack()
	}
}
