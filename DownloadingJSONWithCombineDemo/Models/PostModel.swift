//
//  PostModel.swift
//  DownloadingJSONWithCombineDemo
//
//  Created by Fred Javalera on 6/10/21.
//

import Foundation

struct PostModel: Identifiable, Codable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}
