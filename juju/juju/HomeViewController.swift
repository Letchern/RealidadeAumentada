//
//  HomeViewController.swift
//  juju
//
//  Created by Juliana Santana on 03/06/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emotionImageView: UIImageView?
    @IBOutlet weak var startButton: UIButton?
    @IBOutlet weak var howToButton: UIButton?
    @IBOutlet weak var KidImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    @IBAction func StartGame(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "startGame1") as? ARViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        
        }
    }
    
    @IBAction func HowToPlayGame(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "howToView") as? HowToViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
