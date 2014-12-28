import UIKit

class CardView: UIView {
	var label: UILabel?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.borderColor = UIColor.blackColor().CGColor
		layer.borderWidth = 1.5
		layer.cornerRadius = 5

	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) is not supported")
	}
	
	override func layoutSubviews() {
		label?.frame = bounds
		label?.font = UIFont.systemFontOfSize(round(bounds.height * 0.36))
	}
	
	func showCard(card: Card) {
		if label == nil {
			label = UILabel(frame: bounds)
			label!.textAlignment = NSTextAlignment.Center
			label!.numberOfLines = 2
			addSubview(label!)
		}
		
		label!.text = "\(card.value)\n\(card.suit)"
		backgroundColor = UIColor.clearColor()
	}
}
