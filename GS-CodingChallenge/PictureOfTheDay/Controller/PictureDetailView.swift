//
//  PictureDetailView.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation
import SwiftUI
import UIKit

struct PictureDetailView: View {
    var pictureDetail: PictureOfTheDayModel?
    var viewModel = PictureOfTheDayViewModel()
    @State var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 1.0) {
            if let picture = pictureDetail {
                VStack(alignment: .leading, spacing: 8, content:{
                    Button {
                        if isSelected == false {
                            viewModel.saveFavoriteRecord(record: picture)
                        }
                        isSelected = true
                    } label: {
                        Image(systemName: isSelected == false ? "star" : "star.fill").foregroundColor(.yellow)
                    }
                    Text(picture.date!)
                        .font(.headline)
                    Spacer(minLength: 5.0)
                    HStack(alignment: .top, spacing: 1){
                        CloudAsyncImage(
                            url: URL(string: picture.url!)!,
                            placeholder: { Text("Loading Picture...") },
                            image: { Image(uiImage: $0).resizable() }
                        ).frame(maxWidth: 400.0, maxHeight: 200.0, alignment: .center)
                    }
                    Spacer(minLength: 10.0)
                    Text(picture.title!).font(.title)
                    Text(picture.explanation!).font(.subheadline)
                })
            }
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            PictureDetailView(pictureDetail: nil).preferredColorScheme($0)
        }
    }
}

