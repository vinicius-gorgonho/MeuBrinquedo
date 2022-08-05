//
//  ViewController.swift
//  MeuBrinquedo
//
//  Created by Vinicius on 03/08/22.
//

import UIKit
import Firebase


class FormViewController: UIViewController {

    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var segmentedEstadoBrinquedo: UISegmentedControl!
    @IBOutlet weak var textfieldNomeDoador: UITextField!
    @IBOutlet weak var textfieldEndereco: UITextField!
    
    @IBOutlet weak var textfieldTelefone: UITextField!
    
    @IBOutlet weak var botaoAddEdit: UIButton!
    
    var brinquedoItem: BrinquedoItem!
    
    let collection = "brinquedos"
    lazy var firestore: Firestore = {
    let settings = FirestoreSettings()
    // Ativa a persistencia local
      settings.isPersistenceEnabled = true
      let firestore = Firestore.firestore()
      firestore.settings = settings
      return firestore
    }()
    
  
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let brinquedoItem = brinquedoItem{
        
         print("edicaoooo")
         title = "Edicao"
           
         textFieldNome.text = brinquedoItem.nomeBrinquedo!
   
         textfieldEndereco.text = brinquedoItem.endereco
           
         textfieldTelefone.text = brinquedoItem.telefone!
         textfieldNomeDoador.text = brinquedoItem.nomeDoador

         segmentedEstadoBrinquedo.selectedSegmentIndex = brinquedoItem.estadoConservacao
         botaoAddEdit.setTitle("Alterar Carro", for: .normal)
      
       }
    }

    @IBAction func save(_ sender: UIButton) {
        print("llasdsadasldsadlaldlas")
        
        let nomeBrinquedo = textFieldNome.text!
        let nomeDoador = textfieldNomeDoador.text!
        let estado = segmentedEstadoBrinquedo.selectedSegmentIndex
        let endereco = textfieldEndereco.text!
        let telefone = textfieldTelefone.text!
        
        let data: [String: Any] = [
                     "nome_brinquedo": nomeBrinquedo,
                     "nome_doador": nomeDoador,
                     "estado_conservacao": estado,
                     "telefone": telefone,
                     "endereco": endereco
                 ]
                 
        if let brinquedoItem = brinquedoItem{
                print("123455")
                self.firestore.collection(self.collection).document(brinquedoItem.id!).updateData(data)
         }else{
                self.firestore.collection(self.collection).addDocument(data: data)
         }
        
           goBack()
                 
       }
        
        
    func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
        
    }
    
    



