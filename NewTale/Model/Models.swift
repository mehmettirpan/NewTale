//
//  Models.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import Foundation

// StoryInput struct for user input
struct StoryInput {
//    let title: String
    let age: Int
    let interest: String
    let purpose: String
    let language: String // "en", "tr", "de", "fr", "ru", etc.
}

// Struct for decoding the JSON response
struct PredefinedStoryResponse: Decodable {
    let stories: [PredefinedStory]
}

struct PredefinedStory: Decodable {
    let number: String
    let title: String
    let story: [String]
    let moral: String?
}
