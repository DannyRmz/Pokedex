//
//  ContentView.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 08/01/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var pokemon: [PokemonItem] = []
    var body: some View {
        NavigationStack {
            List(pokemon) { item in
                HStack {
                    AsyncImage(
                        url: URL(
                            string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(item.id).png")) { image in image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                    
                    Text(String(format: "%04d", item.id))
                    Text("\(item.name.capitalized)")
                    NavigationLink("", destination: Pokemon(pokemon: pokemon))
                }
            }
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
    ContentView()
}

struct PokemonResponse: Codable {
    let results: [PokemonItem]
}

struct PokemonItem: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: Int {
        let components = url.split(separator: "/")
        return Int(components.last ?? "0") ?? 0
    }
}

enum PError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
