import UIKit

class GameStartViewController: UIViewController {
	// TODO: need support for save & resume
	let game = Game()
	@IBOutlet weak var cardsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		cardsLabel.text = "1. \(game.userPlayer.hand[0])\n2. \(game.userPlayer.hand[1])\n???\n???"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func begin() {
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
