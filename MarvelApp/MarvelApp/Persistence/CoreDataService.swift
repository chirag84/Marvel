//
//  CoreDataService.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import UIKit
import CoreData


protocol CoreDataServiceProtocol {
    func saveCharactersData(characters: [MarvelCharacter]?,completion: @escaping (Bool) -> ())
    func retrieveCharactersData() -> [MarvelCharacter]? 
}

class CoreDataService: CoreDataServiceProtocol {
    
    func saveCharactersData(characters: [MarvelCharacter]?, completion: @escaping (Bool) -> ()) {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let charactersEntity = NSEntityDescription.entity(forEntityName: Constants.Entity.name, in: managedContext)!
        
        characters?.forEach {
            let character = NSManagedObject(entity: charactersEntity, insertInto: managedContext)
            character.setValue($0.id, forKey: "id")
            character.setValue($0.name, forKey: "name")
            character.setValue($0.thumbnail, forKey: "thumbnail")
            character.setValue($0.description, forKey: "descriptions")
            character.setValue($0.comics, forKey: "comics")
        }
        
        do {
            try managedContext.save()
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    func retrieveCharactersData() -> [MarvelCharacter]? {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.name)
        
        var characters = [MarvelCharacter]()
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
               
                characters.append(MarvelCharacter(id: data.value(forKey: "id") as? Int ?? 0,
                                                  name: data.value(forKey: "name") as? String ?? "",
                                                  thumbnail: data.value(forKey: "thumbnail") as! Thumbnail,
                                                  description: data.value(forKey: "descriptions") as? String ?? "",
                                                  comics: data.value(forKey: "comics") as! Comics))
            }
            
            return characters
            
        } catch {
            print("Failed")
            return []
        }
    }
}
