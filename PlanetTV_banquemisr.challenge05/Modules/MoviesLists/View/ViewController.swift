//
//  ViewController.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var noInternet: UIImageView!
    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    var viewModel: MoviesProtocol?
    var indicator : UIActivityIndicatorView?
    var tabIndex = 0
    var local : LocalManger?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "color1")
        noInternet.isHidden = true
        local = MoviesStorage.shared
        viewModel = MoviesViewModel()
        updateViewForSelectedTab(index: 0)
        moviesCollection.delegate = self
        moviesCollection.dataSource = self
        setIndicator()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        vBack.layer.cornerRadius = 20
        vBack.layer.masksToBounds = true
        monitorNetwork()
        registerCell()
        setupCollectionView()
        self.hideKeyboardWhenTappedAround()
    }
    
}

// MARK: - UISetUp

extension ViewController{
    
    func updateViewForSelectedTab(index: Int) {
        switch index {
        case 0:
            tabIndex = 0
            moviesCollection.reloadData()
        case 1:
            tabIndex = 1
            moviesCollection.reloadData()
        case 2:
            tabIndex = 2
            moviesCollection.reloadData()
        default:
            break
        }
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .color1
        indicator?.center = self.moviesCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        moviesCollection.setCollectionViewLayout(layout, animated: true)
    }
    func registerCell(){
        moviesCollection.register(MovieaCVC.nib(), forCellWithReuseIdentifier: "MovieaCVC")
    }
    func showAlert() {
        let alertController = UIAlertController(title: "No Internet Connection!", message: "Check Your Network Connection or Continue", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            DispatchQueue.main.async {
                self.moviesCollection.isHidden = true
                self.noInternet.isHidden = false
            }
        }
        let continueAction = UIAlertAction(title: "Continue", style: .default) {  _ in
            if let category = self.tabIndex == 0 ? "playingNow" : (self.tabIndex == 1 ? "upcoming" : "popular") {
                self.viewModel?.playingNow = self.local?.fetchMovies(category: category)
                self.viewModel?.upcoming = self.local?.fetchMovies(category: category)
                self.viewModel?.popular = self.local?.fetchMovies(category: category)
                self.moviesCollection.isHidden = false
                self.noInternet.isHidden = true
                DispatchQueue.main.async {
                    self.moviesCollection.reloadData()
                }
            }
        }
        alertController.addAction(continueAction)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.moviesCollection.isHidden = false
                    self?.noInternet.isHidden = true
                    self?.local?.deleteAllMovies()
                    self?.getData()
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


// MARK: - UIcollectionView

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabIndex {
        case 0:
            return viewModel?.playingNow?.count ?? 0
        case 1:
            return viewModel?.upcoming?.count ?? 0
        default:
            return viewModel?.popular?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollection.dequeueReusableCell(withReuseIdentifier: "MovieaCVC", for: indexPath) as! MovieaCVC
        switch tabIndex {
        case 0:
            cell.configureCell(movie:  viewModel?.playingNow?[indexPath.row])
        case 1:
            cell.configureCell(movie:  viewModel?.upcoming?[indexPath.row])
        default:
            cell.configureCell(movie:  viewModel?.popular?[indexPath.row])
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVc") as! MovieDetailsVc
        detailsVC.navigationItem.title = "PlanetTV"
        detailsVC.viewModel = MoviesDetailsViewModel()
        switch tabIndex {
        case 0:
            detailsVC.viewModel?.movieId =  viewModel?.playingNow?[indexPath.row].id
        case 1:
            detailsVC.viewModel?.movieId = viewModel?.upcoming?[indexPath.row].id
        default:
            detailsVC.viewModel?.movieId = viewModel?.popular?[indexPath.row].id
        }
        navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = moviesCollection.frame.width / 2 - 10
        let heightPerItem = moviesCollection.frame.height / 2 - 17
        return CGSize(width:widthPerItem, height:heightPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
}

// MARK: - GetData

extension ViewController{
    func getData(){
        viewModel?.loadPlayingNow()
        viewModel?.loadUpcoming()
        viewModel?.loadPopular()
        viewModel?.bindMoviesToViewController = {[weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.moviesCollection.reloadData()
                self?.local?.storeMovies(self?.viewModel?.playingNow ?? [], category: "playingNow")
                self?.local?.storeMovies(self?.viewModel?.upcoming ?? [], category: "upcoming")
                self?.local?.storeMovies(self?.viewModel?.popular ?? [], category: "popular")
            }
        }
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        updateViewForSelectedTab(index: item.tag)
    }
}
