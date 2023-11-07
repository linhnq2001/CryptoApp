//
//  ImageData.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation

// MARK: - Image
class ImageData: Codable {
    var thumb, small, large: String?

    init(thumb: String?, small: String?, large: String?) {
        self.thumb = thumb
        self.small = small
        self.large = large
    }
}
