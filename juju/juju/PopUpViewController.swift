//
//  PopUpView.swift
//  juju
//
//  Created by Juliana Santana on 08/06/22.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {
    let pauseButton = UIButton(type: .system)
    let resumeButton = UIButton(type: .system)
    let homeButton = UIButton(type: .system)
    let pauseView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = UIColor.yellow
        
        view.addSubview(pauseButton)
        view.addSubview(homeButton)
        
        //butao
        
        let pauseImage = UIImage(systemName: "pause")
        pauseButton.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.5, alpha: 1)
        pauseButton.setImage(pauseImage, for: .normal)
        pauseButton.layer.cornerRadius = 10
        pauseButton.tintColor = .white
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        //botão de pause constraints
        
        let pauseButtonConstraints: [NSLayoutConstraint] = [
            pauseButton.widthAnchor.constraint(equalToConstant: 50),
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ]
        NSLayoutConstraint.activate(pauseButtonConstraints)
        
        pauseButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        
        
    }
    
    @objc func pauseGame() {
        // Crie a conteiner/pop-up
        print("oi")
        
        createView()
        pauseButton.isEnabled = false
    }
    
    
    
    func createView() {
        view.addSubview(pauseView)
        pauseView.addSubview(resumeButton)
        pauseView.addSubview(homeButton)
        pauseView.backgroundColor = .yellow
        pauseView.layer.cornerRadius = 20
        pauseView.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let homeImage = UIImage(named: "home")
        let homeImageView = Imagem2(image: homeImage, action: backHome)
        homeImageView.backgroundColor = .white
        homeImageView.isUserInteractionEnabled = true
        homeButton.setBackgroundImage(homeImage, for: .normal)
        
        
        
        let resumeImage = UIImage(named: "voltar")
        let resumeImageView = MinhaImagem(image: resumeImage, action: resumeGame)
        resumeImageView.backgroundColor = .white
        resumeImageView.isUserInteractionEnabled = true
        resumeButton.setBackgroundImage(resumeImage, for: .normal)
        
        
        
        
        let pauseViewConstraints: [NSLayoutConstraint] = [
            pauseView.widthAnchor.constraint(equalToConstant: 260),
            pauseView.heightAnchor.constraint(equalToConstant: 230),
            pauseView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resumeButton.widthAnchor.constraint(equalToConstant: 180),
            resumeButton.heightAnchor.constraint(equalToConstant: 60),
            resumeButton.centerXAnchor.constraint(equalTo: pauseView.centerXAnchor),
            resumeButton.topAnchor.constraint(equalTo: pauseView.topAnchor, constant: 40),
            
            homeButton.widthAnchor.constraint(equalToConstant: 180),
            homeButton.heightAnchor.constraint(equalToConstant: 60),
            homeButton.centerXAnchor.constraint(equalTo: pauseView.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: pauseView.bottomAnchor, constant: -40),
            
            
        ]
        NSLayoutConstraint.activate(pauseViewConstraints)
        
        
        resumeButton.addTarget(self, action: #selector(resumeGame), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        
    }
    
    
    
    @objc func resumeGame() {
        pauseView.removeFromSuperview()
        pauseButton.isEnabled = true
    }
    
    
    @objc func backHome() {
        func HowToPlayGame(_ sender: Any) {
         //   if let vc = storyboard?.instantiateViewController(withIdentifier: "homeV") as? HomeViewController {
         //       self.presentedViewController(vc, animated: true, completion: nil)
                
                print("oi")
                
            }
            
        }
        }
        
        
        class MinhaImagem: UIImageView {
            
            var action: () -> Void
            
            init(image: UIImage?, action: @escaping () -> Void) {
                self.action = action
                super.init(image: image)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                action()
            }
        }
        
        
        class Imagem2: UIImageView {
            
            var action: () -> Void
            
            init(image: UIImage?, action: @escaping () -> Void) {
                self.action = action
                super.init(image: image)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                action()
            }
        }
    
