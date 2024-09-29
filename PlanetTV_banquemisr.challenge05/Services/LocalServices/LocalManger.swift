//
//  LocalManger.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import Foundation
import CoreData
import UIKit

class MoviesStorage {
    
    // Singleton instance
    static let shared = MoviesStorage()
    
    private init() {} // Private initializer to prevent instantiation
    
    func storeMovies(_ movies: [Movies], category: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for movie in movies {
            guard let movieEntity = NSEntityDescription.entity(forEntityName: "MoviesData", in: managedContext) else { return }
            let movieObject = NSManagedObject(entity: movieEntity, insertInto: managedContext)
            
            // Set values from the Movies struct (excluding genres)
            movieObject.setValue(movie.id, forKey: "id")
            movieObject.setValue(movie.title, forKey: "title")
            movieObject.setValue(movie.backdropPath, forKey: "backdropPath")
            movieObject.setValue(movie.posterPath, forKey: "posterPath")
            movieObject.setValue(movie.overview, forKey: "overview")
            movieObject.setValue(movie.voteAverage, forKey: "voteAverage")
            movieObject.setValue(movie.voteCount, forKey: "voteCount")
            movieObject.setValue(movie.runtime, forKey: "runtime")
            movieObject.setValue(movie.releaseDate, forKey: "releaseDate")
            movieObject.setValue(movie.tagline, forKey: "tagline")
            movieObject.setValue(category, forKey: "category") // Save category
        }
        
        do {
            try managedContext.save()
            print("======== Movies saved successfully ========")
        } catch {
            print("======== Error saving movies ========")
        }
    }
    
    func fetchMovies(category: String? = nil) -> [Movies] {
        var moviesArray = [Movies]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        if let category = category {
            fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        }
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedMovie in result {
                // املأ خصائص الفيلم
                let movie = Movies(
                    id: managedMovie.value(forKey: "id") as! Int,
                    title: managedMovie.value(forKey: "title") as! String,
                    backdropPath: managedMovie.value(forKey: "backdropPath") as? String,
                    posterPath: managedMovie.value(forKey: "posterPath") as? String,
                    overview: managedMovie.value(forKey: "overview") as! String,
                    voteAverage: managedMovie.value(forKey: "voteAverage") as? Double,
                    voteCount: managedMovie.value(forKey: "voteCount") as? Int,
                    runtime: managedMovie.value(forKey: "runtime") as? Int,
                    releaseDate: managedMovie.value(forKey: "releaseDate") as! String,
                    genres: nil,
                    tagline: managedMovie.value(forKey: "tagline") as? String
                )
                moviesArray.append(movie)
            }
        } catch {
            print("======== Error fetching movies ========")
        }
        return moviesArray
    }

    func fetchMovie(id: Int) -> Movies? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        // Create a predicate to filter by movie id
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let managedMovie = results.first {
                // Map the managedMovie to a Movies instance
                let movie = Movies(
                    id: managedMovie.value(forKey: "id") as! Int,
                    title: managedMovie.value(forKey: "title") as! String,
                    backdropPath: managedMovie.value(forKey: "backdropPath") as? String,
                    posterPath: managedMovie.value(forKey: "posterPath") as? String,
                    overview: managedMovie.value(forKey: "overview") as! String,
                    voteAverage: managedMovie.value(forKey: "voteAverage") as? Double,
                    voteCount: managedMovie.value(forKey: "voteCount") as? Int,
                    runtime: managedMovie.value(forKey: "runtime") as? Int,
                    releaseDate: managedMovie.value(forKey: "releaseDate") as! String,
                    genres: nil,
                    tagline: managedMovie.value(forKey: "tagline") as? String
                )
                return movie
            }
        } catch {
            print("======== Error fetching movie by id ========")
        }
        return nil
    }

    func deleteMovie(_ movie: Movies) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        let predicate = NSPredicate(format: "id == %d", movie.id)
        fetchRequest.predicate = predicate
        
        do {
            let movies = try context.fetch(fetchRequest) as! [NSManagedObject]
            for movieObject in movies {
                context.delete(movieObject)
            }
            try context.save()
            print("======== Movie deleted successfully ========")
        } catch {
            print("======== Error deleting movie ========")
        }
    }
    
    func deleteAllMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        do {
            let movies = try context.fetch(fetchRequest) as! [NSManagedObject]
            for movieObject in movies {
                context.delete(movieObject)
            }
            try context.save()
            print("======== All movies deleted successfully ========")
        } catch {
            print("======== Error deleting all movies ========")
        }
    }
}
