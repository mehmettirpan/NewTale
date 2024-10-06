//
//  StoryViewModel.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import Foundation

import Foundation

class StoryViewModel {

    func generateStory(input: StoryInput, completion: @escaping (String) -> Void) {
        NetworkManager.shared.fetchStory(input: input) { result in
            switch result {
            case .success(let story):
                completion(story)
            case .failure(let error):
                print("Error generating story: \(error.localizedDescription)")
                completion("Error generating story: \(error.localizedDescription)")
            }
        }
    }
    
    // This function will return the device's preferred language
    func getDeviceLanguage() -> String {
        let languageCode = Locale.preferredLanguages.first?.prefix(2) ?? "en" // Default to English if language code is unavailable
        return String(languageCode)
    }
}
