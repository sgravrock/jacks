//
//  ComputerPlayer.swift
//  Jacks
//
//  Created by Steve Gravrock on 12/23/14.
//  Copyright (c) 2014 Steve Gravrock. All rights reserved.
//

import UIKit

protocol ComputerPlayerDelegate: class {
	func computerPlayer(computerPlayer: Player, didMove move: Move)
}

class ComputerPlayer: Player {
	weak var delegate: ComputerPlayerDelegate?
	private var mi = 0
	
	func takeTurn(game: Game) {
		// TODO: a better strategy
		mi++
		let cardFromDiscard = maybeTakeDiscard(game)
		let newCard = (cardFromDiscard != nil) ? cardFromDiscard : game.takeTopOfDeck()
		let move = Move(cardTakenFromDiscard: cardFromDiscard, cardDiscarded: hand[mi % 4])
		hand[mi % 4] = newCard! // TODO: Can we fix the initialization of newCard so we don't need to unwrap?
		game.discard(move.cardDiscarded)
		delegate?.computerPlayer(self, didMove: move)
	}
	
	private func maybeTakeDiscard(game: Game) -> Card? {
		let valueShowing = game.topOfDiscards().value
		
		if valueShowing == 1 || valueShowing == 11 {
			return game.takeTopOfDiscards()
		} else {
			return nil
		}
	}	
}
