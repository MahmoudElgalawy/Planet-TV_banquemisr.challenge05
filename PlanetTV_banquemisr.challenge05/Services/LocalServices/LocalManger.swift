//
//  LocalManger.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import Foundation
import CoreData
import UIKit

protocol LocalManger{
    func storeMovies(_ movies: [Movies], category: String)
    func fetchMovies(category: String?) -> [Movies]
//    func fetchMovie(id: Int) -> Movies?
//    func deleteMovie(_ movie: Movies)
    func deleteAllMovies()
}

class MoviesStorage: LocalManger {
    
    static let shared = MoviesStorage()
    private init() {}
    
    private var managedContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve app delegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeMovies(_ movies: [Movies], category: String) {
        for movie in movies {
            guard let movieEntity = NSEntityDescription.entity(forEntityName: "MoviesData", in: managedContext) else { return }
            let movieObject = NSManagedObject(entity: movieEntity, insertInto: managedContext)
            
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
            movieObject.setValue(category, forKey: "category")
        }
        
        do {
            try managedContext.save()
            print("Movies saved successfully")
        } catch {
            print("Error saving movies: \(error)")
        }
    }
    
    func fetchMovies(category: String? = nil) -> [Movies] {
        var moviesArray = [Movies]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        if let category = category {
            fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        }
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for managedMovie in result {
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
            print("Error fetching movies: \(error)")
        }
        return moviesArray
    }

//    func fetchMovie(id: Int) -> Movies? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//        
//        do {
//            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
//            if let managedMovie = results.first {
//                return Movies(
//                    id: managedMovie.value(forKey: "id") as! Int,
//                    title: managedMovie.value(forKey: "title") as! String,
//                    backdropPath: managedMovie.value(forKey: "backdropPath") as? String,
//                    posterPath: managedMovie.value(forKey: "posterPath") as? String,
//                    overview: managedMovie.value(forKey: "overview") as! String,
//                    voteAverage: managedMovie.value(forKey: "voteAverage") as? Double,
//                    voteCount: managedMovie.value(forKey: "voteCount") as? Int,
//                    runtime: managedMovie.value(forKey: "runtime") as? Int,
//                    releaseDate: managedMovie.value(forKey: "releaseDate") as! String,
//                    genres: nil,
//                    tagline: managedMovie.value(forKey: "tagline") as? String
//                )
//            }
//        } catch {
//            print("Error fetching movie by id: \(error)")
//        }
//        return nil
//    }

//    func deleteMovie(_ movie: Movies) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
//        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
//        
//        do {
//            let movies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
//            for movieObject in movies {
//                managedContext.delete(movieObject)
//            }
//            try managedContext.save()
//            print("Movie deleted successfully")
//        } catch {
//            print("Error deleting movie: \(error)")
//        }
//    }
//    
    func deleteAllMovies() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        do {
            let movies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for movieObject in movies {
                managedContext.delete(movieObject)
            }
            try managedContext.save()
            print("All movies deleted successfully")
        } catch {
            print("Error deleting all movies: \(error)")
        }
    }
}

