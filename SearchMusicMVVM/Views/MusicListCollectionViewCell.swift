//
//  MusicListCollectionViewCell.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit
import Kingfisher

class MusicListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
//        setupLayout()
    }
    
    func update(with viewModel: MusicCellViewModel) {
        nameLabel.text = viewModel.title
        artistLabel.text = viewModel.artistName
        genreLabel.text = viewModel.genreName
        releaseDateLabel.text = viewModel.releaseDate
        imageView.kf.setImage(with: URL(string: viewModel.imageURL))
    }
    
    func setupViews() {
//        [labelStackView, imageView].forEach {
//            $0?.translatesAutoresizingMaskIntoConstraints = false
//        }
    }
    
    func setupLayout() {
        imageView.fillSuperview(edges: [.top, .leading, .trailing])
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 170),
            imageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
