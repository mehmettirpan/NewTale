//
//  StoryViewModel.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import Foundation
import CoreData

class StoryViewModel {

    var predefinedStories: [PredefinedStory] = []
    var onStoriesUpdated: (() -> Void)? // A closure to notify the ViewController
    var myStories: [Story] = []

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
    
    // Fetch stories from Core Data (my stories)
    func fetchMyStories() {
        let request: NSFetchRequest<Story> = Story.fetchRequest()
        do {
            let fetchedStories = try CoreDataStack.shared.context.fetch(request)
            self.myStories = fetchedStories
            onStoriesUpdated?()  // Notify when the data is ready
        } catch {
            print("Failed to fetch stories from Core Data: \(error)")
        }
    }
    
    func loadJSONForLanguage(language: String) {
        let fileName: String
        switch language {
        case "Turkish":
            fileName = "predefinedStories_tr"
        case "English":
            fileName = "predefinedStories_en"
        case "German":
            fileName = "predefinedStories_de"
        case "French":
            fileName = "predefinedStories_fr"
        case "Russian":
            fileName = "predefinedStories_ru"
        default:
            fileName = "predefinedStories_en" // Default to English
        }
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decodedResponse = try JSONDecoder().decode(PredefinedStoryResponse.self, from: data)
                self.predefinedStories = decodedResponse.stories
                
                // Notify the ViewController that stories are updated
                onStoriesUpdated?()
                
            } catch {
                print("Failed to load or decode JSON file: \(error)")
            }
        } else {
            print("JSON file not found: \(fileName).json")
        }
    }
    
    func fetchStories() {
        let request: NSFetchRequest<Story> = Story.fetchRequest()

        do {
            let fetchedStories = try CoreDataStack.shared.context.fetch(request)
            myStories = fetchedStories
        } catch {
            print("Hikayeler yüklenemedi: \(error)")
        }
    }
}
