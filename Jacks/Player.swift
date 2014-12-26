//
//  Player.swift
//  Jacks
//
//  Created by Steve Gravrock on 12/23/14.
//  Copyright (c) 2014 Steve Gravrock. All rights reserved.
//

import Foundation

class Player : NSObject {
	var name: String
	var hand = [Card]()
	
	init(name: String) {
		self.name = name
	}
	
	func score() -> Int {
		var result = 0
		
		for card in hand {
			result += card.points()
		}
		
		return result
	}
}