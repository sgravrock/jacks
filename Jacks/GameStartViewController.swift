import UIKit

class GameStartViewController: UIViewController {
	// TODO: need support for save & resume
	let game = Game()
	@IBOutlet weak var handView: HandView!

    override func viewDidLoad() {
        super.viewDidLoad()
		handView!.showCard(card: game.userPlayer.hand[0], index: 0)
		handView!.showCard(card: game.userPlayer.hand[1], index: 1)
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		(segue.destinationViewController as TurnStartViewController).game = game
	}
}
