//
//  MovieaCVC.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import UIKit

class MovieaCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var titleMovie: UILabel!
    var viewModel: MoviesProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 10
        imgMovie.layer.cornerRadius = 10
        viewBack.layer.borderWidth = 2
        viewBack.layer.borderColor = UIColor.orange.cgColor
    }
    
    static func nib()->UINib{
        return UINib(nibName: "MovieaCVC", bundle: nil)
    }
    
    func configureCell(movie:Movies?){
        viewModel = MoviesViewModel()
        titleMovie.text = movie?.title
        releaseYear.text = movie?.releaseDate
        guard let url =  movie?.posterPath else{return}
        let fullImageUrl = "https://image.tmdb.org/t/p/w500" + url
    
        viewModel?.loadImageData(posterPath: fullImageUrl, completion: { [weak self] data in
            guard let data = data else{return}
            DispatchQueue.main.async {
                self?.imgMovie.image = UIImage(data: data)
            }
        })
    }
}
