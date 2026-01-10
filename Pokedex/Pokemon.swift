//
//  Pokemon.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 09/01/26.
//

import SwiftUI

struct Pokemon: View {
    
    @State var pokemon: [PokemonItem] = []
    var body: some View {
        NavigationStack {
            Text("Id")
            Text("Name")
        }

        .task {
            do {
                pokemon = try await getPokemon()
            } catch {
                print(error)
            }
        }
    }
    
    func getPokemon() async throws -> [PokemonItem] {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        guard let url = URL(string: endpoint) else {
            throw PError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(PokemonResponse.self, from: data)
            return decoded.results
        } catch {
            throw PError.invalidData
        }
    }
}

#Preview {
    Pokemon()
}
