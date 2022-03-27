//
//  Favorite.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI

struct Favorite: View {
    @ObservedObject var viewModel = FavoriteViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteModelList) { picture in
                    FavoriteView(pictureDetail: picture)
                }
            } .onAppear {
                self.viewModel.fetchFavoriteRecord()
            }.navigationTitle("Favorite")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
