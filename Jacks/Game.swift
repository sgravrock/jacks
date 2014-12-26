//
//  Game.swift
//  Jacks
//
//  Created by Steve Gravrock on 12/23/14.
//  Copyright (c) 2014 Steve Gravrock. All rights reserved.
//

import UIKit

protocol GameDelegate: ComputerPlayerDelegate {
	// TODO
}

class Game: NSObject, ComputerPlayerDelegate {
	let players = [Player]()
	let userPlayer = Player(name: "User")
	weak var delegate: GameDelegate?
	private let deck = Deck()
	private var discards = [Card]()
	private var currentPlayerIx = 0
	
	override init() {
		super.init()
		deck.shuffle()

		// Create the computer players
		for i in 0...2 {
			let p = ComputerPlayer(name: "Player \(i)")
			p.delegate = self
			players.append(p)
		}
		
		players.append(userPlayer)
		
		// Deal the initial hands
		for i in 0...3 {
			for j in 0...3 {
				players[j].hand.append(deck.pop())
			}
		}
		
		discards.append(deck.pop())
	}
	
	func discard(card: Card) {
		discards.append(card)
	}
	
	func topOfDiscards() -> Card {
		return discards.last!
	}
	
	func takeTopOfDiscards() -> Card {
		return discards.removeLast()
	}
	
	func takeTopOfDeck() -> Card {
		return deck.pop()
	}
	
	func playToNextUserTurn() {
		if !(players[currentPlayerIx] is ComputerPlayer) {
			currentPlayerIx = (currentPlayerIx + 1) % players.count
		}
		
		while let player = players[currentPlayerIx] as? ComputerPlayer {
			if deck.empty() {
				break
			}
			
			println("Taking a computer turn")
			player.takeTurn(self)
			currentPlayerIx = (currentPlayerIx + 1) % players.count
		}
	}
	
	func isFinished() -> Bool {
		return deck.empty()
	}
	
	func winner() -> Player {
		// precondition: game is finished
		var result: Player? = nil
		var minScore = Int.max
		
		for p in players {
			let ps = p.score()
			
			if ps < minScore {
				result = p
				minScore = ps
			}
		}
		
		return result!
	}
	
	func computerPlayer(computerPlayer: Player, didMove move: Move) {
		delegate?.computerPlayer(computerPlayer, didMove: move)
	}
}
