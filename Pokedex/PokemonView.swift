//
//  PokemonView.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 09/01/26.
//

import SwiftUI

struct PokemonView: View {

    let pokemon: PokemonItem
    @State private var evolutions: [Species] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                AsyncImage(url: pokemon.imageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 220)

                Text("\(String(format: "%04d", pokemon.id))")
                    .foregroundStyle(.secondary)

                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .bold()

                if !evolutions.isEmpty {
                    evolutionsView
                }
            }
            .padding()
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .id(pokemon.id)
        .task {
            evolutions = (try? await EvolutionService.getEvolutions(for: pokemon.id)) ?? []
        }
    }

    private var evolutionsView: some View {
        VStack(alignment: .leading) {

            Text("Evolutions")
                .font(.title2)
                .bold()

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(evolutions) { evo in
                        NavigationLink {
                            PokemonView(
                                pokemon: PokemonItem(
                                    name: evo.name,
                                    url: "https://pokeapi.co/api/v2/pokemon/\(evo.id)/"
                                )
                            )
                        } label: {
                            VStack {
                                AsyncImage(
                                    url: URL(
                                        string:
                                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(evo.id).png"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)

                                Text(evo.name.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    PokemonView(pokemon: PokemonItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
