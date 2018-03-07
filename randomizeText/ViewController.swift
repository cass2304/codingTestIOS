//
//  ViewController.swift
//  randomizeText
//
//  Created by Cesar Augusto Sanchez Coraspe on 7/03/18.
//  Copyright © 2018 Cesar Augusto Sanchez Coraspe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var randomTextViewer: UITextView!
	@IBOutlet var randomTextOrigin: UITextField!
	var fontsArray: Array<String> = []
	let alert = UIAlertController(title: "Alert", message: "You must use 5 words", preferredStyle: UIAlertControllerStyle.alert)
	var original: CGFloat = 0.0

	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.size.height == original{
				self.view.frame.size.height = original - keyboardSize.height
				randomTextViewer.centerVertically()
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		self.view.frame.size.height = original
		randomTextViewer.centerVertically()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		for family in UIFont.familyNames {
			let sName: String = family as String
			for name in UIFont.fontNames(forFamilyName: sName) {
			 fontsArray.append(name)
			}
			original = self.view.frame.size.height;
		}
		randomTextOrigin.autocorrectionType = .no
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
	}
	
	@objc func donePressed() {
		view.endEditing(true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func randomizeAction(_ sender: Any) {
	
		if((randomTextOrigin.text?.components(separatedBy: " ").count)! > 5 ){
			return self.present(alert, animated: true, completion: nil);
		} else {
		let combination = NSMutableAttributedString()
		
		for text in (randomTextOrigin.text?.components(separatedBy: " "))! {
			let myAttrString = NSAttributedString(string: text, attributes: randomAttributes())
			combination.append(NSAttributedString(string: " ", attributes: nil))
			combination.append(myAttrString)
		}
		
		randomTextViewer.attributedText = combination
		randomTextViewer.textAlignment = .center
		randomTextViewer.centerVertically()
		}
	}
	
	func randomAttributes () -> [NSAttributedStringKey : Any] {
		let shadow : NSShadow = NSShadow()
		shadow.shadowOffset = CGSize(width: -2.0 , height: CGFloat(arc4random_uniform(UInt32(4))))
		let attributes = [
			NSAttributedStringKey.font : UIFont(
				name: fontsArray[Int(arc4random_uniform(UInt32(fontsArray.count)))],
				size: 30.0)!,
			NSAttributedStringKey.underlineStyle : Int(arc4random_uniform(UInt32(4))),
			NSAttributedStringKey.foregroundColor : getRandomColor(),
			NSAttributedStringKey.backgroundColor: getRandomColor(),
			NSAttributedStringKey.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
			NSAttributedStringKey.strokeWidth : CGFloat(drand48()),
			NSAttributedStringKey.shadow : shadow
			] as [NSAttributedStringKey : Any]
		return attributes;
	}

}

func getRandomColor() -> UIColor{
	
	let randomRed:CGFloat = CGFloat(drand48())
	let randomGreen:CGFloat = CGFloat(drand48())
	let randomBlue:CGFloat = CGFloat(drand48())
	
	return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
	
}

extension UITextView {
	
	func centerVertically() {
		let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
		let size = sizeThatFits(fittingSize)
		let topOffset = (bounds.size.height - size.height * zoomScale) / 2
		let positiveTopOffset = max(1, topOffset)
		contentOffset.y = -positiveTopOffset
	}
	
}
