//
//  MovieDetailsVc.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import UIKit

class MovieDetailsVc: UIViewController {

    @IBOutlet weak var viewBacck: UIView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var tagLine: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var genere: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var runTime: UILabel!
    var viewModel : DetailsProtocol?
    var indicator : UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        viewBacck.layer.cornerRadius = viewBacck.frame.size.width / 2
        viewBacck.layer.masksToBounds = true
        viewBacck.layer.borderWidth = 2
        viewBacck.layer.borderColor = UIColor.orange.cgColor
        overview.isEditable = false
        overview.isSelectable = true
        self.hideKeyboardWhenTappedAround()
        
        viewModel?.getDetails(completion: {
            DispatchQueue.main.async {
                self.indicator?.stopAnimating()
                self.bindDataToUI()
            }
        })

        
    }
    
    private func bindDataToUI() {
        titleMovie.text = viewModel?.movieDetails.title
        releaseDate.text = viewModel?.movieDetails.releaseDate
        
        // Handling runtime display
        runTime.text = "\(viewModel?.movieDetails.runtime ?? 0) m"
        
        overview.text = viewModel?.movieDetails.overview
        let vote = Int(viewModel?.movieDetails.voteAverage ?? 0)
        userScore.text = "\(vote)"
        tagLine.text =  viewModel?.movieDetails.tagline ?? "Are you having a good time?"
        // Genre handling
        if let genres = viewModel?.movieDetails.genres, !genres.isEmpty {
            let genreNames = genres.map { $0.name }
            genere.text = genreNames.joined(separator: ", ")
        } else {
            genere.text = "No genres available"
        }

        // Load Image
        guard let url = viewModel?.movieDetails.backdropPath else { return }
        let fullImageUrl = "https://image.tmdb.org/t/p/w500" + url

        viewModel?.loadImageData(posterPath: fullImageUrl, completion: { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.imgMovie.image = UIImage(data: data)
            }
        })
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    
}
