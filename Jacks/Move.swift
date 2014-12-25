import UIKit

// Describes the move made on a player's turn.
// TODO: expose more details, e.g. whether the player discarded
// the taken card or put it in their hand.
struct Move {
	let cardTakenFromDiscard: Card?
	let cardDiscarded: Card
}
