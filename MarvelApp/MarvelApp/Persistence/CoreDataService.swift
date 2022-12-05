//
//  CoreDataService.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import UIKit
import CoreData


class CoreDataService {
    static let shared = CoreDataService()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MarvelApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func getFavouriteCharacter(_ characterId: Int)-> Bool {
        let context = CoreDataService.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.favorite)
        // Result request limit
        fetchRequest.fetchLimit = 1
        // Remove fault objects
        fetchRequest.returnsObjectsAsFaults = false
        /// Search by marvel character id, return `true` if favorite is equal to true
        fetchRequest.predicate = NSPredicate(format: "id = %d AND isFavorite == %@",
                                             argumentArray:[characterId, NSNumber(value: true)])
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                if let favorite = results.first as? Favorite {
                    return favorite.isFavorite
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        return false
        
    }
    
    // First check if character has bookmarked or not
    // If entity exist then update the bookmarked status
    func checkIfFavoriteCharacterExist(characterId: Int) -> Bool {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Entity.favorite)
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,characterId)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }

        return false
    }
    
    func addToFavorite(characterId: Int, isFavorite: Bool, completion: @escaping (Bool) -> ()) {
        // Create a context from this container
        let managedContext = persistentContainer.viewContext
        let isFavoriteEntityExist = self.checkIfFavoriteCharacterExist(characterId: characterId)
        
        // Update Bookmarked status
        if(isFavoriteEntityExist){
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.Entity.favorite)
            fetchRequest.predicate = NSPredicate(format: "id == %d", characterId)
            do {
                let favorite = try managedContext.fetch(fetchRequest)
                let updateFavorite = favorite[0] as! NSManagedObject
                updateFavorite.setValue(isFavorite, forKey: "isFavorite")
            }
            catch {
                completion(false)
            }
        }else{
            // Create an entity for Bookmarked character
            let favoriteEntity = NSEntityDescription.entity(forEntityName: Constants.Entity.favorite, in: managedContext)!
            let favorite = NSManagedObject(entity: favoriteEntity, insertInto: managedContext)
            favorite.setValue(characterId, forKey: "id")
            favorite.setValue(isFavorite, forKey: "isFavorite")
        }
        
        do {
            try managedContext.save()
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
}

extension NSManagedObjectContext {
    func fetchData<T: NSManagedObject>(entity: T.Type, offset: Int, predicate: NSPredicate? = nil) -> Array<Any> {
        
        let entityName = String(describing: entity.self)
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.entity = entityDescription
        
        // The limit of data to retrive
        fetchRequest.fetchLimit = Constants.API.limit
        
        // The start point from where to get the no. of data
        fetchRequest.fetchOffset = offset
        
        /// If predicate found then filter based on passed offset
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let result = try self.fetch(fetchRequest)
            return result
        } catch {
            fatalError("Failed to fetch \(entityName): \(error)")
        }
    }
    
}
