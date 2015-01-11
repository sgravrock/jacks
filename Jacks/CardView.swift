import UIKit

class CardView: UIControl {
	var label: UILabel = UILabel(frame: CGRectZero)
	
	override var enabled: Bool {
		didSet {
			layer.borderColor = (enabled ? UIColor.blueColor() : UIColor.blackColor()).CGColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		setup()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		label.frame = bounds
		label.font = UIFont.systemFontOfSize(round(bounds.height * 0.36))
	}
	
	func showCard(card: Card) {
		backgroundColor = UIColor.whiteColor()
		label.hidden = false
		label.text = "\(card.value)\n\(card.suit)"
	}
	
	func showBack() {
		backgroundColor = UIColor.lightGrayColor()
		label.hidden = true
	}
	
	func showNothing() {
		backgroundColor = UIColor.clearColor()
		label.hidden = true
	}
	
	private func setup() {
		self.enabled = false
		layer.borderWidth = 1.5
		layer.cornerRadius = 5
		addSubview(label)
		label.textAlignment = NSTextAlignment.Center
		label.numberOfLines = 2
		showBack()
	}
}
