//
//  NetworkLogView.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI

public struct NetworkLogView: View {
    @State var networkLogs: [NetworkLog] = []
    @EnvironmentObject var coreDataManager: NetworkCoreDataManager
    var recordLimit: RecordRange = .all
    let dateformatter = DateFormatter()
    
    public init(numberOfDaysRecord: RecordRange) {
        recordLimit = numberOfDaysRecord
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    }
    
    func fetchNetworkLogs(){
        NetworkCoreDataManager.shared.fetchNetworkLog(recordLimit) { logs in
            networkLogs = logs
            networkLogs.shuffle()
        }
    }
    
    public var body: some View {
        let networkLogs = Dictionary(grouping: networkLogs,
                                     by: {$0.screenname!}).sorted(by: {return $0.key > $1.key})
        if #available(iOS 14.0, *) {
            List {
                ForEach(networkLogs, id: \.key) { key, value in
                    Section(header: Text(key)) {
                        ForEach(value, id:\.self) {
                            LogView(logs: $0, dateformatter: dateformatter)
                        }
                    }
                }
            }.onAppear {
                fetchNetworkLogs()
            }.navigationTitle("Network Logs")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct NetworkLogView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkLogView(numberOfDaysRecord: .all)
    }
}


struct LogView: View {
    var logs: NetworkLog
    @State private var isExpanded: Bool = false
    let dateformatter: DateFormatter
    
    
    var body: some View {
        HStack(spacing: 10.0) {
            VStack(alignment: .leading, spacing: 8, content: {
                if #available(iOS 14.0, *) {
                    Text(dateformatter.string(from: logs.time!) + "  ")
                        .fontWeight(.bold) +
                    Text(logs.action! + "  ")
                        .underline() +
                    Text(logs.result!).font(.headline).foregroundColor( (logs.result == "Sucess") ?  .green : .red)
                    Spacer(minLength: 5.0)
                    HStack(alignment: .center, spacing: 1) {
                        Button("Show Detail", action: {
                            isExpanded.toggle()
                        }).buttonStyle(BorderlessButtonStyle())
                            .accentColor(Color.red)
                    }
                    if isExpanded {
                        Text(logs.action! + logs.notes!.description).font(.body).foregroundColor(.gray)
                    }
                } else {
                    // Fallback on earlier versions
                }
            })
        }
    }
}

struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0
    
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }
    
    func body(content: Content) -> some View {
        content.frame(height: height)
    }
}

