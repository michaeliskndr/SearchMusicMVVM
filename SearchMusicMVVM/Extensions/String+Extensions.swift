//
//  String+Extensions.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

extension String {
    func sizeOf(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
}
