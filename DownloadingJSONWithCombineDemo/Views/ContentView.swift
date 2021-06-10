//
//  ContentView.swift
//  DownloadingJSONWithCombineDemo
//
//  Created by Fred Javalera on 6/10/21.
//

import SwiftUI

struct ContentView: View {
  
  // MARK: Properties
  @StateObject var vm = ContentViewModel()
  
  // MARK: Body
  var body: some View {
    
    List {
      
      ForEach(vm.posts) { post in
        
        VStack(alignment: .leading) {
          
          Text(post.title)
            .font(.headline)
          
          Text(post.body)
            .foregroundColor(.gray)
          
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
      }
      
    }
  
  }

}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
