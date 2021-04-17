//
//  DogAPI.swift
//  Randog
//
//  Created by Fabiana Petrovick on 11/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum EndPoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random" ///random
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    ///pesquisa por raça
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoint.listAllBreeds.url) { (data, response, error)
            in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndpoint = DogAPI.EndPoint.randomImageForBreed(breed).url //buscou a imagem aleatoria
        
        //inicio /** buscou uma resposta JSON contendo o URL da imagem **/
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) //buscou uma resposta JSON contendo o URL da imagem
            in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            //inicio /** exemplo com JSONDecoder: analisar o JSON usando o decoficador JSON*/
            //converteu para json
            let decoder = JSONDecoder()
            //decodifica o JSON
            let imageData = try! decoder.decode(DogImage.self, from: data)
            
            print(imageData)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        //carrega a imagem selecionada ou mostra msg de erro...transforma para url
        /** carregou a imagem na visualizacao de imagem */
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error)
            in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            //baixa a imagem
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
}
