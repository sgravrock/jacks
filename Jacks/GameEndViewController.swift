import UIKit

class GameEndViewController: UIViewController {
	var game: Game!
	@IBOutlet weak var winnerHeader: UILabel!
	@IBOutlet weak var userInfo: UILabel!
	@IBOutlet var computerPlayerInfos: [UILabel]!
	
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

		var computerPlayerIx = 0
		
		for player in game.players {
			if player === game.userPlayer {
				userInfo.text = "You: \(describeHand(player))"
			} else {
				computerPlayerInfos[computerPlayerIx++].text = "\(player.name): \(describeHand(player))"
			}
		}
	}
	
	func describeHand(p: Player) -> String {
		return "\(p.hand[0]), \(p.hand[1]), \(p.hand[2]), \(p.hand[3]): \(p.score()) points"
	}
}
