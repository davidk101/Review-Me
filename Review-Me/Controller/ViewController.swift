//
//  ViewController.swift
//  Review-Me
//
//  Created by David Kumar on 8/28/20.
//  Copyright © 2020 David Kumar. All rights reserved.
//

import UIKit
import VisionKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var ScanSurfaceButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    
    var reviewInfoViewController = ReviewInfoViewController()
    
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        ScanSurfaceButton.configureButton(title: "Scan Text")
        ImageView.configureImageView()
        
        configureOCR()
    }
    
   @IBAction func ButtonPressed() {
    
        scanDocument()
        //self.performSegue(withIdentifier: "ReviewInfoSegue", sender: self)
    
    }
    
    @objc private func scanDocument() {
        
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        //ocrTextView.text = ""
        //scanButton.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            
            try requestHandler.perform([self.ocrRequest])
            
        } catch {
            
            self.performSegue(withIdentifier: "ReviewInfoSegue", sender: self)
            
            self.reviewInfoViewController.addTextToLabel(OCRText: "")
        }
    }
    
    private func configureOCR() {
        
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation]else
            { return }
            
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else
                { return }
                
                ocrText += topCandidate.string + "\n"
            }
        
            DispatchQueue.main.async {
                //self.ocrTextView.text = ocrText
                //self.scanButton.isEnabled = true
                
                self.reviewInfoViewController.addTextToLabel(OCRText: ocrText)
                
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
}

extension UIButton{
    
    func configureButton(title: String){

        self.setTitle(title, for: UIControl.State.normal)
        self.tintColor =  UIColor.init(red: 0.88, green: 0.44, blue: 0.33, alpha: 1)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.init(red: 0.88, green: 0.44, blue: 0.33, alpha: 1).cgColor
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius =  3.0
        self.layer.shadowColor =  UIColor.init(red: 0.88, green: 0.44, blue: 0.33, alpha: 1).cgColor
        self.layer.shadowOpacity =  0.3
        
    }
}

extension UIImageView{
    
    func configureImageView(){
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.init(red: 1.0, green: 0.474, blue: 0.247, alpha: 1.0).cgColor
        
    }
}

// delegate called after scan complete
extension ViewController: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        guard scan.pageCount >= 1 else {
            
            controller.dismiss(animated: true)
            
            self.performSegue(withIdentifier: "ReviewInfoSegue", sender: self)
            
            self.reviewInfoViewController.addTextToLabel(OCRText: "")
            
            return
        }
        
        ImageView.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
 
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        
        controller.dismiss(animated: true)
        
        self.performSegue(withIdentifier: "ReviewInfoSegue", sender: self)
        
        self.reviewInfoViewController.addTextToLabel(OCRText: "")
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        
        controller.dismiss(animated: true)
    }
}

