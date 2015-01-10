import UIKit

// TODO rename
class TurnStartViewController: UIViewController, GameDelegate, HandViewDelegate {
	// TODO: need support for save & resume
	var game: Game!
	var cardTaken: Card?
	
	@IBOutlet weak var log: UILabel!
	@IBOutlet weak var deckView: CardView!
	@IBOutlet weak var discardView: CardView!
	@IBOutlet weak var cardTakenView: CardView!
	@IBOutlet weak var handView: HandView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		log.text = ""
		game.delegate = self
		handView.delegate = self
		playToNextUserTurn()
	}
	
	@IBAction func takeFromDeckSelected(sender: AnyObject) {
		cardTaken = game.takeTopOfDeck()
		assert(cardTaken != nil, "game.takeTopOfDeck() didn't return a card")
		updateUI()
	}
	
	@IBAction func takeFromDiscardSelected(sender: AnyObject) {
		if let c = cardTaken {
			// Discarding
			game.discard(cardTaken!)
			log.text = "You took and discarded the \(cardTaken!)."
			finishTurn()
		} else {
			// Taking from the discard pile
			cardTaken = game.takeTopOfDiscards()
			assert(cardTaken != nil, "takeTopOfDiscards() didn't return a card")
			updateUI()
		}
	}
	
	func destSelected(destIx: Int) {
		let discard = game.userPlayer.hand[destIx]
		game.userPlayer.hand[destIx] = cardTaken!
		game.discard(discard)
		log.text = "You took the \(cardTaken!)\nand discarded the \(discard)"
		finishTurn()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		(segue.destinationViewController as GameEndViewController).game = game
	}
	
	func computerPlayer(computerPlayer: Player, didMove move: Move) {
		var desc = "\(computerPlayer.name) "
		if let fromDiscard = move.cardTakenFromDiscard {
			desc += "took \(fromDiscard) from discard and "
		}
		
		desc += "discarded \(move.cardDiscarded)"
		log.text = "\(log.text!)\n\(desc)"
	}
	
	func game(game: Game, hasNewTopDiscard card: Card?) {
		if let card = card {
			discardView!.showCard(card)
		} else {
			discardView!.hideCard()
		}
	}
	
	func handView(handView: HandView, selectedPosition: Int) {
		destSelected(selectedPosition)
	}
	
	private func updateUI() {
		if let c = cardTaken {
			cardTakenView.showCard(c)
		}
		
		cardTakenView.hidden = cardTaken == nil
		handView.enabled = cardTaken != nil
		deckView.enabled = cardTaken == nil
		discardView.enabled = true // Always enabled, to either take or discard.
		discardView.showCard(game.topOfDiscards())
	}
	
	private func finishTurn() {
		cardTaken = nil
		playToNextUserTurn()
	}

	private func playToNextUserTurn() {
		game.playToNextUserTurn()
		
		if (game.isFinished()) {
			performSegueWithIdentifier("segueToGameEnd", sender: self)
		} else {
			updateUI()
		}
	}

}

