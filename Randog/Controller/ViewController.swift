//
//  ViewController.swift
//  Randog
//
//  Created by Fabiana Petrovick on 11/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DogAPI.requestRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
    }
    //exemplo com JsonSerialization
    //            do {
    //                //converte entre JSON e os objetos Foudation equivalentes
    //                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    //                let url = json["message"] as! String
    //                print(url)
    //            } catch {
    //                print(error)
    //            }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        
        //guard let: garante que a variavel n sera nula
        guard let imageURL = URL(string: imageData?.message ?? "") else {
            return
        }
        
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
        // executar a tarefa
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}
