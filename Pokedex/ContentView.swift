//
//  ContentView.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 08/01/26.
//

import SwiftUI

struct ContentView: View {

    @State private var pokemon: [PokemonItem] = []

    var body: some View {
        NavigationStack {
            List(pokemon) { item in
                NavigationLink {
                    PokemonView(pokemon: item)
                } label: {
                    HStack {

                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)

                        VStack(alignment: .leading) {
                            Text("\(String(format: "%04d", item.id))")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(item.name.capitalized)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
        }
        .task {
            pokemon = (try? await getPokemon()) ?? []
        }
    }

    func getPokemon() async throws -> [PokemonItem] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonResponse.self, from: data).results
    }
}


#Preview {
    ContentView()
}
