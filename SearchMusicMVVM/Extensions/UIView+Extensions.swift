//
//  UIView+Extensions.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

import UIKit

enum Edge {
    case top, leading, bottom, trailing
}

extension UIView {
    func fillSuperview(edges: [Edge] = [.top, .leading, .bottom, .trailing], constant: UIEdgeInsets = .zero ) {
        guard let superview = superview else {
            print("Superview not found, cannot anchor to any view")
            return
        }
        edges.forEach { edge in
            switch edge {
            case .top:
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant.top).isActive = true
            case .leading:
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant.left).isActive = true
            case .bottom:
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant.bottom).isActive = true
            case .trailing:
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant.right).isActive = true
            }
        }
    }
    
    func anchor(to superview: UIView, edges: [Edge] = [.top, .leading, .bottom, .trailing], constant: CGFloat = 0 ) {
        edges.forEach { edge in
            switch edge {
            case .top:
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .leading:
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
            case .bottom:
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            case .trailing:
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
            }
        }
    }

}

