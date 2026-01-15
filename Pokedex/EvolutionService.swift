//
//  EvolutionService.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 14/01/26.
//

import Foundation

struct EvolutionService {

    static func getEvolutions(for id: Int) async throws -> [Species] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let speciesURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)/")!
        let (speciesData, _) = try await URLSession.shared.data(from: speciesURL)
        let species = try decoder.decode(PokemonSpeciesResponse.self, from: speciesData)

        let evolutionURL = URL(string: species.evolutionChain.url)!
        let (evoData, _) = try await URLSession.shared.data(from: evolutionURL)
        let evoChain = try decoder.decode(EvolutionChainResponse.self, from: evoData)

        return parse(evoChain.chain)
    }

    private static func parse(_ chain: ChainLink) -> [Species] {
        var result = [chain.species]
        chain.evolvesTo.forEach {
            result.append(contentsOf: parse($0))
        }
        return result
    }
}

