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
	
	@IBAction func takeFromDeckSelected(_ sender: AnyObject) {
		cardTaken = game.takeTopOfDeck()
		assert(cardTaken != nil, "game.takeTopOfDeck() didn't return a card")
		updateUI()
	}
	
	@IBAction func takeFromDiscardSelected(_ sender: AnyObject) {
		if cardTaken != nil {
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
	
	func destSelected(_ destIx: Int) {
		let discard = game.userPlayer.hand[destIx]
		handView.showCardAnimated(discard, atIndex: destIx) { () -> Void in
			// Clone the relevant card views so we can animate a swap
			let destCardView = self.handView.cardViewAtIndex(destIx)
			let discardingAnimationView = destCardView.cloneInView(self.view)
			discardingAnimationView.showCard(self.game.userPlayer.hand[destIx])
			destCardView.showNothing()

			let takingAnimationView = self.cardTakenView.cloneInView(self.view)
			takingAnimationView.showCard(self.cardTaken!)
			self.cardTakenView.showNothing()
			self.handView.enabled = false
			
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				// Swap the positions of the cards
				var f = discardingAnimationView.frame
				f.origin = self.discardView.convert(self.discardView.bounds.origin, to: self.view)
				discardingAnimationView.frame = f
				
				f = takingAnimationView.frame
				f.origin = destCardView.convert(destCardView.bounds.origin, to: self.view)
				takingAnimationView.frame = f
			}, completion: { (complete) -> Void in
				let when = DispatchTime.now() + Double(Int64(0.35 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
				DispatchQueue.main.asyncAfter(deadline: when, execute: { () -> Void in
					self.game.userPlayer.hand[destIx] = self.cardTaken!
					self.game.discard(discard)
					self.handView.showCard(card: self.cardTaken!, index: destIx)
					discardingAnimationView.removeFromSuperview()
					takingAnimationView.removeFromSuperview()
					self.log.text = "You took the \(self.cardTaken!)\nand discarded the \(discard)"
					self.handView.showBackAnimated(i: destIx, completion: { () -> Void in
						self.finishTurn()
					})
				})
			})
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
		(segue.destination as! GameEndViewController).game = game
	}
	
	func computerPlayer(_ computerPlayer: Player, didMove move: Move) {
		var desc = "\(computerPlayer.name) "
		if let fromDiscard = move.cardTakenFromDiscard {
			desc += "took \(fromDiscard) from discard and "
		}
		
		desc += "discarded \(move.cardDiscarded)"
		log.text = "\(log.text!)\n\(desc)"
	}
	
	func game(_ game: Game, hasNewTopDiscard card: Card?) {
		if let card = card {
			discardView.showCard(card)
		} else {
			discardView.showBack()
		}
	}
	
	func handView(_ handView: HandView, selectedPosition: Int) {
		destSelected(selectedPosition)
	}
	
	fileprivate func updateUI() {
		if let c = cardTaken {
			cardTakenView.showCard(c)
		}
		
		cardTakenView.isHidden = cardTaken == nil
		handView.enabled = cardTaken != nil
		deckView.isEnabled = cardTaken == nil
		discardView.isEnabled = true // Always enabled, to either take or discard.
		
		if let c = game.topOfDiscards() {
			discardView.showCard(c)
		} else {
			// There's no card left on the discard pile. Tell its view not to show anything.
			// (We don't actually hide the view itself because the user needs to be able to 
			// discard the current card by tapping it.
			discardView.showNothing()
		}
	}
	
	fileprivate func finishTurn() {
		cardTaken = nil
		playToNextUserTurn()
	}

	fileprivate func playToNextUserTurn() {
		game.playToNextUserTurn()
		
		if (game.isFinished()) {
			performSegue(withIdentifier: "segueToGameEnd", sender: self)
		} else {
			updateUI()
		}
	}

}

