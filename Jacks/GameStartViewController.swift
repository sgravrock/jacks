import UIKit

class GameStartViewController: UIViewController {
	// TODO: need support for save & resume
	let game = Game()
	@IBOutlet weak var cardsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		cardsLabel.text = "1. \(game.userPlayer.hand[0])\n2. \(game.userPlayer.hand[1])\n???\n???"
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		(segue.destinationViewController as TurnStartViewController).game = game
	}
}
