//
//  MusicListViewController.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = viewModel.description
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "MusicListCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MusicListCell")
            collectionView.register(UINib(nibName: "LoadingFooterCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingFooter")
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.isHidden = true
        }
    }
    
    private let viewModel: MusicListViewViewModel
    
    init(viewModel: MusicListViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("View Controller Does Not Implemented Yet")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMusics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.reload = { [weak self] in
            self?.fetchingHandler()
            self?.collectionView.reloadData()
        }
        viewModel.errorHandler = { [weak self] in
            self?.fetchingHandler()
            self?.errorHandler()
        }
    }

    func setupViews() {
        setupNavigationBar()
    }
    
    func fetchingHandler() {
        viewModel.isFetching ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
    
    func errorHandler() {
        errorLabel.isHidden = !viewModel.hasError
        errorLabel.text = viewModel.errorDescription
    }
    
    func setupNavigationBar() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.delegate = self
    }

}

extension MusicListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMusics(query: searchText)
    }
}

extension MusicListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Item Spacing -> --
        // left-rightPadding = sectionInset.left + sectionInsetRight -> **
        // itemPerRow -> vvvvv
        // view simulation -> |**vvvvv--vvvvv**|
//        let itemPerRow: CGFloat = 2
//        let leftRightPadding: CGFloat = 32
//        let itemSpacing: CGFloat = 10
        let width = view.frame.width 
        return .init(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Section inset
        return .init(top: 8, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Spacing between row
        return 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        if (offsetY > contentSizeHeight - scrollViewHeight), !viewModel.isPaginating {
            viewModel.fetchMoreData()
        }
        
        print("\(offsetY) ContentoffSetY, \(contentSizeHeight) Content Size Height, \(scrollViewHeight) scrollView Height \n")
        print("\(offsetY) ContentoffsetY, \(contentSizeHeight - scrollViewHeight)")
    }
}

extension MusicListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellForRowAt = viewModel.cellForRow(at: indexPath)
        switch cellForRowAt {
        case .musicList(let musicCellViewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicListCell", for: indexPath) as! MusicListCollectionViewCell
            cell.update(with: musicCellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingFooter", for: indexPath) as! LoadingFooterCollectionReusableView
        footer.isLoading(viewModel.isPaginating, done: viewModel.isDonePaginating)
        return footer
    }
}
