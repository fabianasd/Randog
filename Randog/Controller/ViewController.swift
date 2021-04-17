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
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
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
    
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
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

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
}
