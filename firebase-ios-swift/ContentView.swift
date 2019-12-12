//
//  ContentView.swift
//  firebase-ios-swift
//
//  Created by Mathieu • EdgeAngel on 12/12/2019.
//  Copyright © 2019 EdgeAngel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //var buttonSize: Length = 30
    
    var body: some View {
        Image("logo").resizable()
        .frame(width: 100.0, height: 100.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
