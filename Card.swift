import UIKit

enum Suit: CustomStringConvertible {
	case clubs, hearts, spades, diamonds
	
	var description : String {
		switch self {
		case .clubs: return "♣"
		case .hearts: return "♥"
		case .spades: return "♠"
		case .diamonds: return "♦"
		}
	}
}

enum CardValue: Int, CustomStringConvertible {
	case ace = 1,
	two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10,
	jack = 11, queen = 12, king = 13
	
	var description: String {
		if self == CardValue.ace {
			return "A"
		} else if self == CardValue.jack {
			return "J"
		} else if self == CardValue.queen {
			return "Q"
		} else if self == CardValue.king {
			return "K"
		} else {
			return "\(rawValue)"
		}
	}
}

struct Card: CustomStringConvertible, Equatable {
	let suit: Suit
	let value: CardValue
	
	func points() -> Int {
		switch (value) {
		case CardValue.jack:
			return 0
		case CardValue.queen, CardValue.king:
			return 10
		default:
			return value.rawValue
		}
	}
	
	var description: String {
		return "\(value)\(suit)"
	}
}

func ==(lhs: Card, rhs: Card) -> Bool {
	return lhs.suit == rhs.suit && lhs.value == rhs.value
}
