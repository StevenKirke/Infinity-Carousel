//
//  Home.swift
//  Custom Infinity Carousel
//
//  Created by Steven Kirke on 01.04.2023.
//

import SwiftUI

struct Home: View {
    
    var body: some View {
        Carousel()
    }
}

#if DEBUG
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
#endif
