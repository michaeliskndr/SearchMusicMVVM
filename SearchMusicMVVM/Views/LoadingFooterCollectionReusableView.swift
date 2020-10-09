//
//  LoadingFooterCollectionReusableView.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 14/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

class LoadingFooterCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    func isLoading(_ animated: Bool, done: Bool) {
        if !animated && done {
            loadingLabel.isHidden = true
            activityIndicatorView.stopAnimating()
        } else {
            loadingLabel.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }
}
