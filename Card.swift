//
//  Card.swift
//  Jacks
//
//  Created by Steve Gravrock on 12/23/14.
//  Copyright (c) 2014 Steve Gravrock. All rights reserved.
//

import UIKit

enum Suit: Printable {
	case Clubs, Hearts, Spades, Diamonds
	
	var description : String {
		switch self {
		case Clubs: return "Clubs"
		case Hearts: return "Hearts"
		case Spades: return "Spades"
		case Diamonds: return "Diamonds"
		}
	}
}

struct Card: Printable {
	let suit: Suit
	let value: Int // A=1, J=11, Q=12, K=13
	
	func points() -> Int {
		if value == 11 {
			return 0
		}
		
		return value
	}
	
	var description: String {
		return "\(value) of \(suit)"
	}
}
