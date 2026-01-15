//
//  Models.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 14/01/26.
//

import Foundation

// Lista inicial
struct PokemonResponse: Codable {
    let results: [PokemonItem]
}

// Pokemon base
struct PokemonItem: Codable, Identifiable {
    let name: String
    let url: String

    var id: Int {
        Int(url.split(separator: "/").last ?? "0") ?? 0
    }

    var imageURL: URL? {
        URL(string:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        )
    }
}

// Species
struct PokemonSpeciesResponse: Codable {
    let evolutionChain: EvolutionChainURL
}

struct EvolutionChainURL: Codable {
    let url: String
}

// Evolution chain
struct EvolutionChainResponse: Codable {
    let chain: ChainLink
}

struct ChainLink: Codable {
    let species: Species
    let evolvesTo: [ChainLink]
}

// Pokemon evolución
struct Species: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: Int {
        let components = url.split(separator: "/")
        return Int(components.last ?? "0") ?? 0
    }
}
