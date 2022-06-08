//
//  ARViewController.swift
//  juju
//
//  Created by Juliana Santana on 08/06/22.
//

import Foundation
import UIKit
import SceneKit
import ARKit


class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    
    // MARK: - Botão de Pause Declarando
    let pauseButton = UIButton(type: .system)
     let resumeButton = UIButton(type: .system)
     let homeButton = UIButton(type: .system)
    let pauseView = UIView(frame: .zero)
    // MARK: - Botão de Pause Declarado
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = UIColor.yellow
        // MARK: - Botão de Pause Sendo adicionado na View
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
        // MARK: - Botão de Pause adicionado na View
        
        
        sceneView.delegate = self
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let device = sceneView.device {
            let faceMeshGeometry = ARSCNFaceGeometry(device: device)
            let node = SCNNode(geometry: faceMeshGeometry)
            node.geometry?.firstMaterial?.fillMode = .lines
            
            return node
        } else {
            fatalError("No device found")
        }
    }
    
    
    
    var analysis = ""
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            expression(anchor: faceAnchor)
            DispatchQueue.main.async {
        //        self.faceLabel.text = self.analysis
            }
        }
    }
    
   // let possibles: ARFaceAnchor.BlendShapeLocation = []
    
    func expression(anchor: ARFaceAnchor) {
        
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        
        let tongue = anchor.blendShapes[.tongueOut]
        
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        
        let sadEyeLeft = anchor.blendShapes[.mouthFrownLeft]
        let sadEyeRight = anchor.blendShapes[.mouthFrownRight]
        let sadBrowLeft = anchor.blendShapes[.browDownLeft]
        let sadBrowRight = anchor.blendShapes[.browDownRight]
        
        let browR = anchor.blendShapes [.browOuterUpRight]
        let browL = anchor.blendShapes [.browOuterUpLeft]
    
        
        
        self.analysis = ""
        
        if let cheekPuffValue = cheekPuff?.decimalValue {
            if cheekPuffValue > 1 {
                self.analysis += "You're cheeks are puffed!"
            }
        }
        
        if let tongueValue = tongue?.decimalValue {
            if tongueValue > 0.1 {
                self.analysis += "Don't stick your tonge out!"
            }
        }
        
        if ((smileLeft?.decimalValue ?? 0.0) +
                  (smileRight?.decimalValue ?? 0.0)) > 0.2 {
                  self.analysis += "You are smiling"
              }
        
        if let sadLValue = sadEyeLeft?.decimalValue, let sadRValue = sadEyeRight?.decimalValue, let sadBLValue = sadBrowLeft?.decimalValue, let sadRBValue = sadBrowRight?.decimalValue {
            if sadLValue > 0.1 && sadRValue > 0.1 && sadBLValue > 0.05 && sadRBValue > 0.05 {
                self.analysis += "You are sad :("
            }
        }
        
        if let browLValue = browL?.decimalValue, let browRValue = browR?.decimalValue {
                        if browLValue > 0.3 && browRValue > 0.3 {
                            self.analysis += "Surprise"
                        }
                }
    
        
       
    }
    
    
    // MARK: - Botão de Pause

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
        

    
    
}
