//
//  ImageCache.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 13.09.2022.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
