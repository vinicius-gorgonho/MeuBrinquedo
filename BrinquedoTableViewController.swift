//
//  BrinquedoTableViewController.swift
//  MeuBrinquedo
//
//  Created by Vinicius on 03/08/22.
//

import UIKit
import Firebase

class BrinquedoTableViewController: UITableViewController {

    let collection = "brinquedos"
    var listener: ListenerRegistration!
    
    var brinquedoList: [BrinquedoItem] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBrinquedosList()
    }

    func loadBrinquedosList(){
        print("loading...")
        listener = firestore.collection(collection).order(by: "nome_brinquedo", descending: true).addSnapshotListener(
            includeMetadataChanges: true, listener: { snapshot, error in
                
                if let error = error {
                    print(error)
                }else{
                    print("Nao deu erro")
                    guard let snapshot = snapshot else {return}
                    print("Total itens alterados \(snapshot.documentChanges.count)")
                    
                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0{
                        print("x")
                        print(snapshot.metadata)
                        self.showItemsFrom(snapshot)
                    }
                }
                
            return
            })
    
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot){
      
        brinquedoList.removeAll()
        print(snapshot.documents.count)
        for document in snapshot.documents {
              let data  = document.data()
              print(data)
              let brinquedoItem = BrinquedoItem()
                
                brinquedoItem.nomeBrinquedo = data["nome_brinquedo"] as? String
                brinquedoItem.estadoConservacao = data["estado_conservacao"] as? Int ?? 0
                brinquedoItem.telefone = data["telefone"] as? String
                brinquedoItem.nomeDoador = data["nome_doador"] as? String
                brinquedoItem.endereco = data["endereco"] as? String
                brinquedoItem.id = document.documentID
                
                brinquedoList.append(brinquedoItem)
            }
       
        
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let formViewController = segue.destination as? FormViewController,
            let row = tableView.indexPathForSelectedRow?.row{
                formViewController.brinquedoItem = brinquedoList[row]
                formViewController.firestore = firestore
            }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return brinquedoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let brinquedoItem = brinquedoList[indexPath.row]
        cell.textLabel?.text = brinquedoItem.nomeBrinquedo
        cell.detailTextLabel?.text = brinquedoItem.estado
       

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let brinquedoItem = brinquedoList[indexPath.row]
            firestore.collection(collection).document(brinquedoItem.id!).delete()
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

    

}
