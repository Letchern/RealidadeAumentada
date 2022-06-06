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
        
        
        howToButton?.setTitle("", for: .normal)
        
        let buttonHow = UIImage(named: "howbutton")
        howToButton?.setImage(buttonHow?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
    }
    
}
