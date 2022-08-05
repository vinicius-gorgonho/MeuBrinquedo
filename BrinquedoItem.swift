//
//  BrinquedoItem.swift
//  MeuBrinquedo
//
//  Created by Vinicius on 04/08/22.
//

import Foundation

class BrinquedoItem{
    var nomeBrinquedo: String? = ""
    var estadoConservacao: Int = 0
    var nomeDoador: String? = ""
    var telefone: String? = ""
    var endereco: String? = ""
    var id: String? = ""
    
    var estado: String{
        switch estadoConservacao{
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        default:
            return "Precisa de Reparo"
        }
}
    
}
