//
//  NetworkManager.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import Foundation
import GoogleGenerativeAI

enum APIKey {
    // Fetch the API key from `GenerativeAI-Info.plist`
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError("Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key.")
        }
        return value
    }
}

class NetworkManager {
    static let shared = NetworkManager()

    let generativeModel: GenerativeModel

    private init() {
        // Gemini model is being used here
        generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKey.default
        )
    }

    // Function to fetch the story based on user input
    func fetchStory(input: StoryInput, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = "Write a story for a \(input.age)-year-old child who likes \(input.interest). The purpose of the story is \(input.purpose)."

        Task {
            do {
                let response = try await generativeModel.generateContent(prompt)
                if let story = response.text {
                    completion(.success(story))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case parsingError
    case invalidParameters
}