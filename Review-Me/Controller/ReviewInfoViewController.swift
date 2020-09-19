//
//  ReviewInfoViewController.swift
//  Review-Me
//
//  Created by David Kumar on 9/2/20.
//  Copyright © 2020 David Kumar. All rights reserved.
//

import Foundation
import UIKit

class ReviewInfoViewController: UIViewController{
    
    @IBOutlet weak var OCRLabel: UILabel!
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        OCRLabel.configureLabel()
        
    }
    
    func addTextToLabel(OCRText: String){
        
        if OCRText != ""{
            
            OCRLabel.text = OCRText
        }
        else{
            OCRLabel.text = "Could not recognize the text. Please try again."
            
        }
        
    }
}

extension UILabel{
    
    func configureLabel(){
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.init(red: 1.0, green: 0.474, blue: 0.247, alpha: 1.0).cgColor
        
    }
}
