//
//  ViewController.swift
//  juju
//
//  Created by Juliana Santana on 03/06/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet weak var faceLabel2: UILabel!
   
    @IBOutlet weak var homeButton: UIButton!
   
    
    @IBOutlet weak var emotionLabel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.layer.cornerRadius = 10
        
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
                self.faceLabel.text = self.analysis
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
    
    
    
    
    
    
    
    
    
    
    
}
