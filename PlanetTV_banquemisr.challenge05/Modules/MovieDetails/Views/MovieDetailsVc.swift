//
//  MovieDetailsVc.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import UIKit
import Network
import WebKit

class MovieDetailsVc: UIViewController {
    
    @IBOutlet weak var productionCountries: UILabel!
    @IBOutlet weak var productionCompanies: UILabel!
    @IBOutlet weak var viewBacck: UIView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var tagLine: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var genere: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel : DetailsProtocol?
    var indicator : UIActivityIndicatorView?
    var videoURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: view.frame.width, height: 896)
        setIndicator()
        getMovieTrailer()
        viewBacck.layer.cornerRadius = viewBacck.frame.size.width / 2
        viewBacck.layer.masksToBounds = true
        viewBacck.layer.borderWidth = 2
        viewBacck.layer.borderColor = UIColor.color1.cgColor
        overview.isEditable = false
        overview.isSelectable = true
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monitorNetwork()
    }
    
}



// Mark:- Update UI
extension MovieDetailsVc {
//    private func loadDefaultImageInWebView() {
//        // تأكد من وجود الصورة في الـ Assets
//        guard let image = UIImage(named: "trailer") else {
//            print("Image not found")
//            return
//        }
//        
//        // تحويل الصورة إلى بيانات Base64
//        guard let imageData = image.pngData() else { return }
//        let base64String = imageData.base64EncodedString()
//        
//        // إنشاء HTML يتضمن الصورة
//        let htmlString = """
//        <html>
//        <body style="margin:0;padding:0;">
//        <img src="data:image/png;base64,\(base64String)" width="100%" height="100%" />
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(htmlString, baseURL: nil)
//    }

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
        
        runTime.text = "\(convertMinutesToHoursAndMinutes(minutes: viewModel?.movieDetails.runtime ?? 0).0) h , \(convertMinutesToHoursAndMinutes(minutes: viewModel?.movieDetails.runtime ?? 0).1) m"
        overview.text = viewModel?.movieDetails.overview
        let vote = Int(viewModel?.movieDetails.voteAverage ?? 0)
        userScore.text = "\(vote) / 10"
        tagLine.text =  viewModel?.movieDetails.tagline ?? "Are you having a good time?"
        // Genre handling
        if let genres = viewModel?.movieDetails.genres, !genres.isEmpty {
            let genreNames = genres.map { $0.name }
            genere.text = genreNames.joined(separator: ", ")
        } else {
            genere.text = "No genres available"
        }
        if let productionComp = viewModel?.movieDetails.productionCompanies, !productionComp.isEmpty {
            let productionCompNames = productionComp.map { $0.name }
            productionCompanies.text = productionCompNames.joined(separator: ", ")
        } else {
            productionCompanies.text = "No production Companies available"
        }
        if let productionCount = viewModel?.movieDetails.productionCountries, !productionCount.isEmpty {
            let productionCountNames = productionCount.compactMap { $0.name }
            productionCountries.text = productionCountNames.joined(separator: ", ")
        } else {
            productionCountries.text = "No production Countries available"
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
    
    private func getMovieTrailer() {
        guard let movieId = viewModel?.movieId else { return }
        viewModel?.fetchMovieVideos(id: movieId, completion: { [weak self] result in
            switch result {
            case .success(let videos):
                if let firstVideo = videos.first(where: { $0.type == "Trailer" && $0.site == "YouTube"}) {
                        self?.loadTrailer(videoKey: firstVideo.key)
                }
            case .failure(let error):
                print("Error fetching videos: \(error.localizedDescription)")
            }
        })
    }
    
    func convertMinutesToHoursAndMinutes(minutes: Int) -> (Int,Int) {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return (hours, remainingMinutes)
    }
    private func loadTrailer(videoKey: String) {
           let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoKey)")!
           let request = URLRequest(url: youtubeURL)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
       }
}

