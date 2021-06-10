//
//  ContentViewModel.swift
//  DownloadingJSONWithCombineDemo
//
//  Created by Fred Javalera on 6/10/21.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
  
  // MARK: Properties
  @Published var posts: [PostModel] = []
  var cancellables = Set<AnyCancellable>()
  
  // MARK: Init
  init() {
    getPosts()
  }
  
  
  // MARK: Methods
  
  /// Retrieves a list of posts from url and updates UI.
  func getPosts() {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    
    // Network calls using Combine framework. Steps:
    /*
     1. Create the publisher.
     2. Put (subscribe) the publisher on a background thread. ".dataTaskPublisher" does this by default but I'm going to explicitly do it anyway to develop good habits.
     3. Receive on main thread.
     4. Check that the data is good (tryMap).
     5. Decode data into models (in this case, PostModels).
     6. Put the item into our app (sink).
     7. Allow for cancellation of subscription if needed (store in cancellables).
     */
    
    //1
    URLSession.shared.dataTaskPublisher(for: url)
      //2 - This line not actually needed here in this example, since ".dataTaskPublisher" does this by default.
      .subscribe(on: DispatchQueue.global(qos: .background))
      //3 - Needed before we update the UI in subsequent steps.
      .receive(on: DispatchQueue.main)
      //4 - References handleOutput helper method.
      .tryMap(handleOutput)
      //5
      .decode(type: [PostModel].self, decoder: JSONDecoder())
      //6 - (Preferred) If errors occur in completionHandler, print error. Then post returned posts to UI.
      .sink { completionHandler in
        switch completionHandler {
        case .finished:
          print("finished!")
        case .failure(let error):
          print("There was an error. \(error)")
        }
      } receiveValue: { [weak self] returnedPosts in
        self?.posts = returnedPosts
      }
      
      //6 - (Alternative, not preferred since individual errors aren't printed) If errors occur during decode, replace data with empty array and post to UI.
      //      .replaceError(with: [])
      //      .sink(receiveValue: { [weak self] returnedPosts in
      //        self?.posts = returnedPosts
      //      })
      
      //7
      .store(in: &cancellables)
    
  }
  
  /// Helper method that handles output.
  /// - Parameter output: Response data.
  /// - Throws: URLError - if bad server response.
  /// - Returns: Response data.
  func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard
      let response = output.response as? HTTPURLResponse,
      response.statusCode >= 200 && response.statusCode < 300 else {
      throw URLError(.badServerResponse)
    }
    return output.data
  }
  
}
