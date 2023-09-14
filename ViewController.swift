//
//  ViewController.swift
//  agrotech_prot2
//
//  Created by Ibrahim Gok on 18.04.2023.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var buttonChar: UIButton!
    @IBOutlet weak var greyView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    var runMotor = Bool()
    var checkLabel = String()
    
    let firestoreabase = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greyView.layer.cornerRadius = 25
                
    }

    @IBAction func buttonClicked(_ sender: Any) {
        
        firestoreabase.collection("Info").addSnapshotListener { [self] snapshot, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    // Verilerin Derlenmesi
                    for document in snapshot!.documents {
                        if let value = document.get("Value") as? Bool {
                            if value == false {
                                checkLabel = "Hastalık Bulunmadı."
                                print(checkLabel)
                                runMotor = false
                            } else if value == true {
                                checkLabel = "Hastalık Bulundu!"
                                print(checkLabel)
                                messageToUser()
                            }
                        }
                    }
                }
            }
        }
        imageView.image = UIImage(named: "plant_image")
        
    }
    
    func messageToUser() {
        
        let alert = UIAlertController(title: "Uyarı", message: "Araç Hastalıklı Bitki Tespit Etti!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Bitkiyi Sök", style: .default) { (action) in
            
            let ref = self.firestoreabase.document("Info/MBJVfGSyebBGKEF9gOWK")
            ref.setData(["Value": false])
            
            let F_ref = self.firestoreabase.document("Info/OZR2OVu1rV0lX8pyxvz9")
            F_ref.setData(["FunctionValue": true])
            
            let alert2 = UIAlertController(title: "Araç", message: "Bitki Sökülüyor.", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert2, animated: true, completion: nil)
            
        })
        
        alert.addAction(UIAlertAction(title: "Bitkiyi İlaçla", style: .default) { (action) in
            
            let ref = self.firestoreabase.document("Info/MBJVfGSyebBGKEF9gOWK")
            ref.setData(["Value": false])
            
            let F_ref = self.firestoreabase.document("Info/OZR2OVu1rV0lX8pyxvz9")
            F_ref.setData(["FunctionValue": false])
            
            let alert3 = UIAlertController(title: "Araç", message: "Bitki İlaçlanıyor.", preferredStyle: .alert)
            alert3.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert3, animated: true, completion: nil)
            
        })
        present(alert, animated: true, completion: nil)
    }
    
}

