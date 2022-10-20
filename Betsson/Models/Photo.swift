//
//  PhotoModel.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 19/10/2022.
//

struct Photo: Identifiable, Decodable, Equatable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
}
