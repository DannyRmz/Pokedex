//
//  PokemonView.swift
//  Pokedex
//
//  Created by Daniel Ramirez on 09/01/26.
//

import SwiftUI

struct PokemonView: View {
    
    let pokemon: PokemonItem
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(
                        string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png")) { image in image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 250)
                
                Text(String(format: "%04d", pokemon.id))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PokemonView(pokemon: PokemonItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
