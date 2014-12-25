//
//  ViewController.swift
//  Jacks
//
//  Created by Steve Gravrock on 12/23/14.
//  Copyright (c) 2014 Steve Gravrock. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameDelegate {
	// TODO: need support for save & resume
	let game = Game()
	
	@IBOutlet weak var log: UILabel!
	@IBOutlet weak var topCardBtn: UIButton!
	@IBOutlet weak var discardBtn: UIButton!
	@IBOutlet var destBtns: [UIButton]!
	@IBOutlet weak var moveBtn: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		log.text = ""
		updateMoveButton()
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
		discardBtn.setTitle("Top discard: \(game.topOfDiscards())", forState: UIControlState.Normal)
	}
	
	func updateMoveButton() {
		var hasSource = false, hasDest = false
		
		for btn in [topCardBtn, discardBtn] {
			if btn.selected {
				hasSource = true
			}
		}
		
		for btn in destBtns {
			if btn.selected {
				hasDest = true
			}
		}
		
		moveBtn.enabled = hasSource && hasDest
	}
	
	func selectedDestIx() -> Int {
		for var i = 0; i < destBtns.count; i++ {
			if destBtns[i].selected {
				return i
			}
		}
		
		return -1
	}

	@IBAction func sourceSelected(sender: UIButton) {
		for btn in [topCardBtn, discardBtn] {
			btn.selected = btn == sender
		}
		
		updateMoveButton()
	}
	
	@IBAction func destSelected(sender: UIButton) {
		for btn in destBtns {
			btn.selected = btn == sender
		}
		
		updateMoveButton()
	}
	
	@IBAction func performMove(sender: UIButton) {
		let cardTaken = topCardBtn.selected ? game.takeTopOfDeck() : game.takeTopOfDiscards()
		let i = selectedDestIx()
		let discard = game.userPlayer.hand[i]
		game.userPlayer.hand[i] = cardTaken
		game.discard(discard)
		log.text = "You took the \(cardTaken)\nand discarded the \(discard)"
		playToNextUserTurn()
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

