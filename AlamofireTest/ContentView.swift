//
//  ContentView.swift
//  AlamofireTest
//
//  Created by watanabe on 2020/06/13.
//  Copyright © 2020 SEPV CORPORATION. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    @ObservedObject var obs = observer()
    
    var body: some View {
        VStack{
            List(obs.datas){
                i in
                HStack{
                    Text(i.name_ja)
                    Text("\(i.deaths)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct datatype: Identifiable{
    var id : String
    var name_ja: String
    var deaths: Int
}

class observer : ObservableObject{
    @Published var datas = [datatype]()
    init(){
        AF.request("https://covid19-japan-web-api.now.sh/api//v1/prefectures")
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    for(key,subJson):(String, JSON) in json{
                        debugPrint("============================")
                        debugPrint(subJson["name_ja"])
                        debugPrint("============================")
                        debugPrint("key: \(key) subJson: \(subJson)")
                        self.datas.append(datatype(
                            id: key,
                            name_ja:subJson["name_ja"].stringValue,
                            deaths:subJson["deaths"].intValue))
                    }
                case .failure(let error):
                    debugPrint(error)
                }
                
        }
    }
}
