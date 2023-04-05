//
//  ExtentionImage.swift
//  Custom Infinity Carousel
//
//  Created by Steven Kirke on 01.04.2023.
//

import SwiftUI

extension Image {
    
    enum Poster: String {
        case Batman
        case BladeRunner
        case Criticism
        case HiddenThreat
        case Logan
        case PacificRim
        case Skyscraper
        case StarWar
        case TheDeadDie
    }

    init(_ name: Image.Poster) {
        self.init(name.path)
    }
    
    static let batman = Image(Poster.Batman)
    static let bladeRunner = Image(Poster.BladeRunner)
    static let criticism = Image(Poster.Criticism)
    static let hiddenThreat = Image(Poster.HiddenThreat)
    static let logan = Image(Poster.Logan)
    static let pacificRim = Image(Poster.PacificRim)
    static let skyscraper = Image(Poster.Skyscraper)
    static let starWar = Image(Poster.StarWar)
    static let theDeadDie = Image(Poster.TheDeadDie)
}

extension Image.Poster {
    var path: String {
        "Posters/\(rawValue)"
    }
}
