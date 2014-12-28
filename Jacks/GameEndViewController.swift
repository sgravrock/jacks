import UIKit

class GameEndViewController: UIViewController {
	var game: Game!
	@IBOutlet weak var winnerHeader: UILabel!
	@IBOutlet var computerPlayerHandViews: [HandView]!
	@IBOutlet var computerPlayerHeaders: [UILabel]!
	@IBOutlet weak var userHandView: HandView!
	@IBOutlet weak var userHeader: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		assert(game.players.count == 4)
		assert(game.isFinished())
		let winner = game.winner()
		
		if winner === game.userPlayer {
			winnerHeader.text = "You won!"
		} else {
			winnerHeader.text = "\(winner.name) won."
		}
		
		var i = 0
		
		for player in game.players {
			if player === game.userPlayer {
				userHandView.showHand(player.hand)
				userHeader.text = "You: \(player.score()) points"
			} else {
				computerPlayerHandViews[i].showHand(player.hand)
				computerPlayerHeaders[i].text = "\(player.name): \(player.score()) points"
				i++
			}
		}

	}
	
	func describeHand(p: Player) -> String {
		return "\(p.hand[0]), \(p.hand[1]), \(p.hand[2]), \(p.hand[3]): \(p.score()) points"
	}
}
