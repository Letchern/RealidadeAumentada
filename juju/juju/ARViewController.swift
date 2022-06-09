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
    @IBOutlet weak var palavraEmocao: UILabel!
    @IBOutlet weak var labelEmocao: UILabel!
    @IBOutlet weak var jujuEmot: UIImageView!
    @IBOutlet weak var faceLabel: UILabel!
    var emocao: String = "Alegria"
    var count: Int = 0
    var emocoes: [String] = ["Alegria", "Raiva", "Tristeza"]
  
    // MARK: - Botão de Pause Declarando
    let pauseButton = UIButton(type: .system)
    let howToPlay = UIButton(type: .system)
     let resumeButton = UIButton(type: .system)
     let homeButton = UIButton(type: .system)
    let pauseView = UIView(frame: .zero)
    // MARK: - Botão de Pause Declarado
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faceLabel.layer.masksToBounds = true
        faceLabel.layer.cornerRadius = 10
        
        
        labelEmocao.text = emocoes[0]
        // view.backgroundColor = UIColor.yellow
        // MARK: - Botão de Pause Sendo adicionado na View
        view.addSubview(pauseButton)
        view.addSubview(howToPlay)
        view.addSubview(homeButton)
        
        
        // botão ?
        let questionimg = UIImage(systemName: "questionmark")
        howToPlay.backgroundColor = UIColor(red: 41/255, green: 104/255, blue: 182/255, alpha: 1)
        howToPlay.setImage(questionimg, for: .normal)
        howToPlay.layer.cornerRadius = 10
        howToPlay.tintColor = .white
        howToPlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        let howToPlayConstraints: [NSLayoutConstraint] = [
            howToPlay.widthAnchor.constraint(equalToConstant: 50),
            howToPlay.heightAnchor.constraint(equalToConstant: 50),
            howToPlay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 312),
            howToPlay.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(howToPlayConstraints)
//
//        howToPlay.addTarget(self, action: #selector(howToView), for: .touchUpInside)
        howToPlay.addTarget(self, action: #selector(handlePresentingVC(_:)), for: .touchUpInside)

        //butao
        
        let pauseImage = UIImage(systemName: "pause")
        pauseButton.backgroundColor = UIColor(red: 41/255, green: 104/255, blue: 182/255, alpha: 1)
        pauseButton.setImage(pauseImage, for: .normal)
        pauseButton.layer.cornerRadius = 10
        pauseButton.tintColor = .white
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        //botão de pause constraints
        
        let pauseButtonConstraints: [NSLayoutConstraint] = [
            pauseButton.widthAnchor.constraint(equalToConstant: 50),
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(pauseButtonConstraints)
        
        pauseButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        // MARK: - Botão de Pause adicionado na View
        
        jujuEmot.image = UIImage(named: "\(emocoes[count]).png")
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
            node.geometry?.firstMaterial?.transparency = 0.0
            
            return node
        } else {
            fatalError("No device found")
        }
    }
    var analysis = ""
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
          
            DispatchQueue.main.async {
                self.faceLabel.text = self.analysis
                self.expression(anchor: faceAnchor)
            }
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
     
        self.analysis = ""
        
        switch emocoes[count] {
        case "Alegria":
            let smileLValue = self.getExpressionValue(with: .mouthSmileLeft, for: anchor) > 0.6
            let smileRValue = self.getExpressionValue(with: .mouthSmileRight, for: anchor) > 0.6
            if smileLValue && smileRValue {
                self.analysis += "Você está alegre"
                self.btnAction()
            } else if !smileLValue || !smileRValue {
                self.analysis += "Tente mexer os lábios"
            }
            if smileLValue && smileRValue {
                self.faceLabel.backgroundColor = UIColor.green
            } else {
                self.faceLabel.backgroundColor = UIColor.clear
            }
            
        case "Tristeza":
            let sadL = self.getExpressionValue(with: .mouthPressLeft, for: anchor) > 0.1
            let sadR = self.getExpressionValue(with: .mouthPressRight, for: anchor) > 0.1
            let browDownL = self.getExpressionValue(with: .browDownLeft, for: anchor) > 0.2
            if browDownL && sadL && sadR {
                self.analysis += "Você está triste"
                self.btnAction()
            } else if !sadL || !sadR  {
                self.analysis += "Tente abaixar os lábios"
            } else if !browDownL {
                self.analysis += "Tente abaixar as sobrancelhas"
            }
            if browDownL && sadL && sadR {
                self.faceLabel.backgroundColor = UIColor.green
            } else {
                self.faceLabel.backgroundColor = UIColor.clear
            }

        case "Raiva":
            let eyeLOpen = self.getExpressionValue(with: .eyeWideLeft, for: anchor) > 0.3
            let eyeROpen = self.getExpressionValue(with: .eyeWideRight, for: anchor) > 0.3
            let browDownL = self.getExpressionValue(with: .browDownLeft, for: anchor) > 0.2
            let browDownR = self.getExpressionValue(with: .browDownRight, for: anchor) > 0.2
            if eyeLOpen && eyeROpen && browDownL && browDownR {
                self.analysis += "Você está com raiva"
                self.btnAction()
            } else if !eyeLOpen || !eyeROpen {
                self.analysis += "Tente abrir os olhos"
            } else if !browDownL || !browDownR {
                self.analysis += "Tente juntar as sobrancelhas"
            }
            if eyeLOpen && eyeROpen && browDownL && browDownR {
                self.faceLabel.backgroundColor = UIColor.green
            } else {
                self.faceLabel.backgroundColor = UIColor.clear
            }
//
//        case "Neutro":
//            let eyeLOpen = self.getExpressionValue(with: .eyeWideLeft, for: anchor) > 0.2
//            let eyeROpen = self.getExpressionValue(with: .eyeWideRight, for: anchor) > 0.2
//            let mouthNormalL = self.getExpressionValue(with: .mouthStretchLeft, for: anchor) > 0.2
//            let mouthNormalR = self.getExpressionValue(with: .mouthStretchRight, for: anchor) > 0.2
//            if eyeLOpen && eyeROpen && mouthNormalL && mouthNormalR {
//                self.analysis += "Você está relaxado"
//                self.btnAction()
//            } else if !eyeLOpen || !eyeROpen {
//                self.analysis += "Tente abrir os olhos"
//            } else if !mouthNormalL || !mouthNormalR {
//                self.analysis += "Tente deixar os lábios retos"

            
            
        default: break
        }
        

    }
        

    
    
    /// Pega valor de uma determinada expressão
        func getExpressionValue(with expression: ARFaceAnchor.BlendShapeLocation, for anchor: ARFaceAnchor) -> Decimal {
            let expression = anchor.blendShapes[expression]

            if let value = expression?.decimalValue {
                return value
            }
            return -1
        }

    
    @objc func btnAction() {
        if count < 2 {
            count += 1
            jujuEmot.image = UIImage(named: "\(emocoes[count]).png")
            labelEmocao.text = emocoes[count]
            
            
          
        }
        
        let haptickFeedback = UINotificationFeedbackGenerator()
        haptickFeedback.notificationOccurred(.error)
        
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
            pauseView.backgroundColor = .systemYellow
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
        
    @objc func handlePresentingVC(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "howToView") as? HowToViewController {
            self.present(vc, animated: true, completion: nil)
        }
       
     }
        
        @objc func backHome() {
            self.dismiss(animated: true)
                
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
