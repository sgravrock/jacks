import UIKit

protocol GameDelegate: ComputerPlayerDelegate {
	func game(game: Game, hasNewTopDiscard: Card?)
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
		delegate?.game(self, hasNewTopDiscard: card)
	}
	
	func topOfDiscards() -> Card? {
		return discards.last
	}
	
	func takeTopOfDiscards() -> Card {
		let result = discards.removeLast()
		delegate?.game(self, hasNewTopDiscard: discards.last)
		return result
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
		let candidates = findByLowestScore(players, computeScore: {$0.score()})
		
		if candidates.count == 1 {
			return candidates[0]
		} else if let winner = breakTieByJackCount(candidates) {
			return winner
		} else {
			return breakTieByHighestJack(candidates)
		}
	}
	
	func breakTieByJackCount(candidates: [Player]) -> Player? {
		let winners = findByHighestScore(candidates, computeScore: { (p) -> Int in
			p.hand.filter({$0.value == CardValue.Jack}).count
		})
		
		if winners.count == 1 {
			return winners[0]
		} else {
			return nil
		}
	}
	
	func breakTieByHighestJack(candidates: [Player]) -> Player {
		var suitsByRank = [Suit.Diamonds, Suit.Clubs, Suit.Hearts, Suit.Spades]
		var ranked = findByHighestScore(candidates, computeScore: { (p) -> Int in
			var score = -1
			for c in p.hand {
				if c.value == CardValue.Jack {
					score = max(score, find(suitsByRank, c.suit)!)
				}
			}
			return score
		})
		return ranked[0]
	}
	
	// Returns the player(s) with the lowest score according to the supplied score function
	func findByLowestScore(candidates: [Player], computeScore: (Player) -> Int) -> [Player] {
		var winners = [Player]()
		var lowestScore = Int.max
		
		for p in candidates {
			let score = computeScore(p)
			
			if score < lowestScore {
				winners = [p]
				lowestScore = score
			} else if score == lowestScore {
				winners.append(p)
			}
		}
		
		return winners
	}
	
	func findByHighestScore(candidates: [Player], computeScore: (Player) -> Int) -> [Player] {
		return findByLowestScore(candidates, computeScore: {-1 * computeScore($0)})
	}
	
	func computerPlayer(computerPlayer: Player, didMove move: Move) {
		delegate?.computerPlayer(computerPlayer, didMove: move)
	}
}
