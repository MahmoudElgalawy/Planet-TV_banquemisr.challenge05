//
//  localDetailsManger.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 29/09/2024.
//
//MoviesDataEntity
//GenreDataEntity

import Foundation
import CoreData
import UIKit

class MoviesDetailsStorage {
    
    // Singleton instance
    static let shared = MoviesDetailsStorage()
    
    private init() {} // Private initializer to prevent instantiation
    
    func storeMovie(_ movie: Movies) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let movieEntity = NSEntityDescription.entity(forEntityName: "MoviesDataEntity", in: managedContext) else { return }
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
        
        // Handle genres
        if let genres = movie.genres {
            let genreSet = NSMutableSet()
            for genre in genres {
                guard let genreEntity = NSEntityDescription.entity(forEntityName: "GenreDataEntity", in: managedContext) else { continue }
                let genreObject = NSManagedObject(entity: genreEntity, insertInto: managedContext)
                genreObject.setValue(genre.id, forKey: "id")
                genreObject.setValue(genre.name, forKey: "name")
                genreSet.add(genreObject)
            }
            movieObject.setValue(genreSet, forKey: "genres")
        }

        do {
            try managedContext.save()
            print("+++++++ Movie saved successfully +++++++")
        } catch {
            print("+++++++ Error saving movie +++++++")
        }
    }
    
    func fetchMovie(id: Int) -> Movies? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesDataEntity")
        
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let managedMovie = results.first {
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
                    genres: fetchGenres(for: managedMovie),
                    tagline: managedMovie.value(forKey: "tagline") as? String
                )
                return movie
            } else {
                print("======== No movie found for id: \(id) ========")
            }
        } catch {
            print("======== Error fetching movie by id: \(error.localizedDescription) ========")
        }
        return nil
    }

    private func fetchGenres(for movie: NSManagedObject) -> [Genre]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        _ = appDelegate.persistentContainer.viewContext
        
        // Fetch genres related to the movie
        let genresSet = movie.value(forKey: "genres") as? NSSet
        var genresArray: [Genre] = []
        
        genresSet?.forEach { genreObject in
            if let genreManagedObject = genreObject as? NSManagedObject,
               let id = genreManagedObject.value(forKey: "id") as? Int,
               let name = genreManagedObject.value(forKey: "name") as? String {
                let genre = Genre(id: id, name: name)
                genresArray.append(genre)
            }
        }
        
        return genresArray
    }

    func deleteMovie(_ movie: Movies) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesDataEntity")
        let predicate = NSPredicate(format: "id == %d", movie.id)
        fetchRequest.predicate = predicate
        
        do {
            let movies = try context.fetch(fetchRequest) as! [NSManagedObject]
            for movieObject in movies {
                // Delete associated genres
                if let genres = movieObject.value(forKey: "genres") as? NSSet {
                    for genreObject in genres {
                        if let genreManagedObject = genreObject as? NSManagedObject {
                            context.delete(genreManagedObject)
                        }
                    }
                }
                // Delete the movie
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesDataEntity")
        
        do {
            let movies = try context.fetch(fetchRequest) as! [NSManagedObject]
            for movieObject in movies {
                // Delete associated genres
                if let genres = movieObject.value(forKey: "genres") as? NSSet {
                    for genreObject in genres {
                        if let genreManagedObject = genreObject as? NSManagedObject {
                            context.delete(genreManagedObject)
                        }
                    }
                }
                // Delete the movie
                context.delete(movieObject)
            }
            try context.save()
            print("+++++++ All movies deleted successfully +++++++")
        } catch {
            print("+++++++ Error deleting all movies +++++++")
        }
    }
}
