import UIKit

protocol GameDelegate: ComputerPlayerDelegate {
	// TODO
}

class Game: NSObject, ComputerPlayerDelegate {
	let players = [Player]()
	let userPlayer = Player(name: "User")
	weak var delegate: GameDelegate?
	private var deck: Deck
	private var discards = [Card]()
	private var currentPlayerIx = 0
	
	override convenience init() {
		let deck = Deck()
		deck.shuffle()
		self.init(deck:deck)
	}
	
	init(deck: Deck) {
		self.deck = deck
		super.init()
		
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
			
			player.takeTurn(self)
			currentPlayerIx = (currentPlayerIx + 1) % players.count
		}
	}
	
	func isFinished() -> Bool {
		return deck.empty()
	}
	
	func winner() -> Player {
		// precondition: game is finished
		var candidates : [Player] = []
		var minScore = Int.max
		
		for p in players {
			let ps = p.score()
			
			if ps < minScore {
				candidates = [p]
				minScore = ps
			} else if ps == minScore {
				candidates.append(p)
			}
		}
		
		if candidates.count == 1 {
			return candidates[0]
		} else {
			return breakTie(candidates)
		}
	}
	
	func breakTie(candidates: [Player]) -> Player {
		if let winner = breakTieByJackCount(candidates) {
			return winner
		}
		
		return breakTieByHighestJack(candidates)
	}

	func breakTieByJackCount(candidates: [Player]) -> Player? {
		var winners = [Player]()
		var winnerJackCount = -1

		for p in candidates {
			let jacks = p.hand.filter({$0.value == CardValue.Jack})

			if jacks.count > winnerJackCount {
				winners = [p]
				winnerJackCount = jacks.count
			} else if jacks.count == winnerJackCount {
				winners.append(p)
			}
		}

		if winners.count == 1 {
			return winners[0]
		} else {
			return nil
		}
	}
	
	func breakTieByHighestJack(candidates: [Player]) -> Player {
		var suitsByRank = [Suit.Diamonds, Suit.Clubs, Suit.Hearts, Suit.Spades]
		var winner: Player? = nil
		var winnerScore = -1
		
		for p in candidates {
			var score = -1
			for c in p.hand {
				if c.value == CardValue.Jack {
					score = max(score, find(suitsByRank, c.suit)!)
				}
			}
			
			if score > winnerScore {
				winner = p
				winnerScore = score
			}
		}
		
		if let w = winner {
			return w
		} else {
			// None of the candidates had any jacks.
			// This is *exteremly* unlikely, but theoretically possible.
			// Pick a winner arbitrarily.
			return candidates[0]
		}
	}
	
	func computerPlayer(computerPlayer: Player, didMove move: Move) {
		delegate?.computerPlayer(computerPlayer, didMove: move)
	}
}
