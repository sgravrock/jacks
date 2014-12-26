import UIKit

// TODO rename
class TurnStartViewController: UIViewController, GameDelegate {
	// TODO: need support for save & resume
	var game: Game!
	var cardTaken: Card?
	
	@IBOutlet weak var log: UILabel!
	@IBOutlet weak var topCardBtn: UIButton!
	@IBOutlet weak var takeFromDiscardBtn: UIButton!
	@IBOutlet weak var destWrapper: UIView!
	@IBOutlet weak var cardTakenLabel: UILabel!
	@IBOutlet var destBtns: [UIButton]!
	@IBOutlet weak var discardBtn: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		log.text = ""
		game.delegate = self
		playToNextUserTurn()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func playToNextUserTurn() {
		game.playToNextUserTurn()
		
		if (game.isFinished()) {
			performSegueWithIdentifier("segueToGameEnd", sender: self)
//			var s = ""
//			for p in game.players {
//				s += "\(p.name) score: \(p.score())\n"
//			}
//			s += "\(game.winner()) wins"
//			log.text = s
//			destWrapper.hidden = true
		} else {
			takeFromDiscardBtn.setTitle("Top discard: \(game.topOfDiscards())", forState: UIControlState.Normal)
			self.destWrapper.hidden = true
			self.topCardBtn.enabled = true
			self.takeFromDiscardBtn.enabled = true
		}
	}
	
	@IBAction func takeFromDeckSelected(sender: AnyObject) {
		cardTaken = game.takeTopOfDeck()
		assert(cardTaken != nil, "game.takeTopOfDeck() didn't return a card")
		cardWasTaken()
	}
	
	@IBAction func takeFromDiscardSelected(sender: AnyObject) {
		cardTaken = game.takeTopOfDiscards()
		assert(cardTaken != nil, "takeTopOfDiscards() didn't return a card")
		cardWasTaken()
	}
	
	@IBAction func destSelected(sender: UIButton) {
		println("Hand before: \(game.userPlayer.hand)")
		let i = find(destBtns, sender)!
		let discard = game.userPlayer.hand[i]
		game.userPlayer.hand[i] = cardTaken!
		game.discard(discard)
		log.text = "You took the \(cardTaken!)\nand discarded the \(discard)"
		cardTaken = nil
		println("Hand after: \(game.userPlayer.hand)")
		playToNextUserTurn()
	}
	
	@IBAction func discardCardTaken(sender: AnyObject) {
		game.discard(cardTaken!)
		log.text = "You took and discarded the \(cardTaken!)."
		cardTaken = nil
		playToNextUserTurn()
	}
	
	func cardWasTaken() {
		topCardBtn.enabled = false
		takeFromDiscardBtn.enabled = false
		destWrapper.hidden = false
		cardTakenLabel.text = "You took the \(cardTaken)."
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
}

