//
//  ViewController.swift
//  Aprendiendo-Servicios
//
//  Created by Jorge Alejndro Marcial Galvan on 08/08/23.
//

import UIKit
import Alamofire

//1. Crear modelo Codable (estructura)
//2. Utilizar JSONDecodable para serializar Data a Modelo

struct Human: Codable {
    let user: String
    let age: Int
    let isHappy: Bool
}

class ViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchService()
    }
    
    //EndPoint: https://www.mocky.io/v2/5e2674472f00002800a4f417
    //1. Crear la excepción de seguridad
    //2. Crear URL con el endpoint
    //3. Hacer request con la ayuda de URLSession
    //4. Transformar respuesta de diccionario
    //5. Ejecutar Request

    private func fetchService(){
        let endpointString = "https://www.mocky.io/v2/5e2674472f00002800a4f417"
        //Consumimos el servico
        guard let endpoint = URL(string: endpointString) else {
            return
        }
        
        //Iniciar el loader
        activityIndicator.startAnimating()
        
        AF.request(endpoint, method: .get, parameters: nil).responseData { (response: AFDataResponse<Data>) in
            //Detener el loader
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if response.error != nil {
                print("Hubo un error!")
                
                return
            }
            //Validamos que exista un data, si hay data lo tratamos de convertir en diccionario
            guard
                let dataFromService = response.data,
                let model: Human = try? JSONDecoder().decode(Human.self, from: dataFromService) else{
                
                return
            }
            
            //Importante: Todos los llamados a la UI, se hacen en el main thread (Pregunta de entrevista)
            DispatchQueue.main.async {
                //Le asignamos el data al label
                self.nameLabel.text = model.user
                self.statusLabel.text = model.isHappy ? "Es feliz!!" : "Es triste!"
            }
        }
    }

}

