//
//  NetworkManager.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import Foundation
import GoogleGenerativeAI

enum APIKey {
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
        generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKey.default
        )
    }

    // Function to fetch the story based on user input and language
    func fetchStory(input: StoryInput, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = createPrompt(input: input)

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

    // Function to create the prompt based on the language
    private func createPrompt(input: StoryInput) -> String {
        switch input.language {
        case "tr":
            var prompt = "\(input.age) yaşındaki \(input.interest) ile ilgilenen çocuğa yönelik bir masal ve bu masala uygun bir başlık yaz. Masalın vermek istediği mesaj: \(input.purpose). Çıktı formatı şu şekilde olmalıdır; ## ile başlığı belirteceksin alt satırında konuyu Konu:... şeklinde yazmalısın ve onun altında ise masal'ı yazmalısın, başlığını ## olarak belirtmelisin"
            
            // Opsiyonel değerler ekleniyor
            if let mainCharacter = input.mainCharacter {
                prompt += "\nBaşrol: \(mainCharacter)"
            }
            
            if let storyLocation = input.storyLocation {
                prompt += "\nHikaye Nerede Geçiyor: \(storyLocation)"
            }
            return prompt
        case "de":
            return "Schreibe eine Geschichte für ein \(input.age)-jähriges Kind, das sich für \(input.interest) interessiert. Der Zweck der Geschichte ist \(input.purpose)."
        case "fr":
            return "Écris une histoire pour un enfant de \(input.age) ans qui aime \(input.interest). Le but de l'histoire est \(input.purpose)."
        case "ru":
            return "Напишите рассказ для ребенка \(input.age) лет, который интересуется \(input.interest). Цель рассказа — \(input.purpose)."
        default:
            return "Write a story for a \(input.age)-year-old child who likes \(input.interest). The purpose of the story is \(input.purpose)."
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
