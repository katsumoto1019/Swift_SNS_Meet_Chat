//
//  SearchVC.swift
//  Tenorize
//
//  Created by Eric Giannini on 8/29/18.
//  Copyright © 2018 Eric Giannini. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SearchVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var uiv_dlgBack: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    @IBOutlet weak var cons_btm_colSearchView: NSLayoutConstraint!
    
    @IBOutlet weak var cons_h_dlgBack: NSLayoutConstraint!
    // MARK: - Data
    
    internal lazy var resultsArray: [GIF] = []
    
    internal let cellIdentifier = "PreviewCell"
    
    internal let cellHeight: CGFloat = 250
    
    private let anonIdViewModel = AnonIdViewModel()
    
    private let searchViewModel = SearchViewModel()
    var num = -1
    
    // MARK: - View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        num = -1
        self.hideKeyboardWhenTappedAround()
        
        self.cons_h_dlgBack.constant = Constants.SCREEN_HEIGHT / 3 * 2.5
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            if let bottomPadding = bottomPadding{
                self.cons_btm_colSearchView.constant = bottomPadding + 60
            }else{
                self.cons_btm_colSearchView.constant = 60
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard1),name:.gifSearch, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gifSendSuccess),name:.gifSendSuccess, object: nil)
        
        fetchAnonymousId()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.orientationDidChange), name:UIDevice.orientationDidChangeNotification, object: nil)
        uiv_dlgBack.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ViewController Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        resultCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func hideKeyboard1(){
        view.endEditing(true)
    }
    
    @objc func gifSendSuccess(){
        self.num = -1
    }
    
    // MARK: - Methods
    
    private func fetchAnonymousId() {
        
        ActivityIndicator.startAnimating()
        
        anonIdViewModel.getAnonymousId { [weak self] success in
            
            ActivityIndicator.stopAnimating()
            
            if success {
                self?.fetchResult()
            } else {
                self?.showRetryAlert()
            }
        }
    }
    
    private func fetchResult(for keyword: String = "") {
        
        ActivityIndicator.startAnimating()
        
        searchViewModel.search(using: keyword) { [weak self] (data, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    // Do not show error alert if, request was cancelled.
                    guard (error as NSError).code != -999 else { return }
                    self?.showErrorAlert(with: error.localizedDescription)
                }
                else if let data = data {
                    self?.resultsArray = data
                    
                    self?.resultCollectionView.reloadData()
                }
                
                ActivityIndicator.stopAnimating()
            }
        }
    }
    
    @objc
    func orientationDidChange() {
        resultCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func showRetryAlert() {
        
        let alertController = UIAlertController(title: "Error",
                                                message: "Unable to fetch anonymous id.",
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchAnonymousId()
        }
        alertController.addAction(retryAction)
        
        let withoutAction = UIAlertAction(title: "Search without anonymous id.", style: .default) { [weak self] _ in
            self?.fetchResult()
        }
        alertController.addAction(withoutAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okayAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func topLineClicked(_ sender: Any) {
        
        self.closeMenu(.gifSearch)
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        fetchResult(for: searchText)
    }
}

