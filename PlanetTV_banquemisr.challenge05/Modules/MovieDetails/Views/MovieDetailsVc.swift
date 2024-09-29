//
//  MovieDetailsVc.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import UIKit
import Network

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
    var imageView : UIImageView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        viewBacck.layer.cornerRadius = viewBacck.frame.size.width / 2
        viewBacck.layer.masksToBounds = true
        viewBacck.layer.borderWidth = 2
        viewBacck.layer.borderColor = UIColor.color1.cgColor
        overview.isEditable = false
        overview.isSelectable = true
        self.hideKeyboardWhenTappedAround()
        
        let image = UIImage(named: "nointernet")
        imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        imageView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monitorNetwork()
    }
}



// Mark:- Update UI
extension MovieDetailsVc {
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    private func bindDataToUI() {
        titleMovie.text = viewModel?.movieDetails.title
        releaseDate.text = viewModel?.movieDetails.releaseDate
        runTime.text = "\(viewModel?.movieDetails.runtime ?? 0) m"
        overview.text = viewModel?.movieDetails.overview
        let vote = Int(viewModel?.movieDetails.voteAverage ?? 0)
        userScore.text = "\(vote)/10"
        tagLine.text =  viewModel?.movieDetails.tagline ?? "Are you having a good time?"
        // Genre handling
        if let genres = viewModel?.movieDetails.genres, !genres.isEmpty {
            let genreNames = genres.map { $0.name }
            genere.text = genreNames.joined(separator: ", ")
        } else {
            genere.text = "No genres available"
        }
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
        indicator?.color = .color1
        indicator?.center = view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    
                    self?.viewModel?.getDetails(completion: {
                        DispatchQueue.main.async {
                            self?.indicator?.stopAnimating()
                            self?.bindDataToUI()
                        }
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert()
                    self?.indicator?.stopAnimating()
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
