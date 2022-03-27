//
//  PictureOfTheDay.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI
import GSNetworkManager

struct PictureOfTheDay: View {
    @ObservedObject var viewModel = PictureOfTheDayViewModel()
    @StateObject var selectedDate = PassDateObject(Date())
    @State private var showingPopover = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pictureDetailList) { picture in
                    PictureDetailView(pictureDetail: picture)
                }
            } .onAppear {
                self.viewModel.getPictureOfTheDay()
            }.navigationTitle("Picture Of The Day")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                                        Button {
                    isDarkMode = isDarkMode == true ? false : true
                } label: {
                    Image(systemName: "gearshape.fill")
                },
                                    trailing:
                                        Button {
                    showingPopover = true
                } label: {
                    Image(systemName: "calendar")
                }
                ).popover(isPresented: $showingPopover, attachmentAnchor: .point(.bottomTrailing), arrowEdge: .trailing) {
                    iOSDatePicker(updateDetail: self.fetchPictureOfTheDayForSelectedDate).environmentObject(selectedDate)
                }
        }
    }
    
    func fetchPictureOfTheDayForSelectedDate(){
        self.viewModel.getPictureOfTheDayForSelectedDate(self.viewModel.string(_date: selectedDate.date))
    }
}

class PassDateObject: ObservableObject {
    @Published var date: Date
    init(_ date: Date) {
        self.date = date
    }
}

struct iOSDatePicker: View {
    
    @EnvironmentObject var selectedDate: PassDateObject
    @Environment(\.presentationMode) var presentationMode
    var updateDetail: ()-> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Date", selection: $selectedDate.date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                Spacer()
            }
            .navigationBarTitle(Text("Select Date"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                        updateDetail()
                    }
                }
            }
        }
        .accentColor(.red)
    }
}
