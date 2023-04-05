//
//  InfinityNumber.swift
//  Custom Infinity Carousel
//
//  Created by Steven Kirke on 02.04.2023.
//

import SwiftUI

struct PosterForFilm {
    var image: Image
    var title: String
}

struct Carousel: View {
    
   var Test: [PosterForFilm] = [
        PosterForFilm(image: .batman, title: "Batman"),
        PosterForFilm(image: .bladeRunner, title: "Blade Runner"),
        PosterForFilm(image: .criticism, title: "Criticism"),
        PosterForFilm(image: .hiddenThreat, title: "Hidden Threat"),
        PosterForFilm(image: .logan, title: "Logan"),
        PosterForFilm(image: .pacificRim, title: "Pacific Rim"),
        PosterForFilm(image: .skyscraper, title: "Skyscraper"),
        PosterForFilm(image: .starWar, title: "Star War"),
        PosterForFilm(image: .theDeadDie, title: "The Dead Die")
    ]
    
    
    var body: some View {
        VStack(spacing: 0) {
            InfinityCarousel(views: Test)
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct InfinityCarousel: View {
    
    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation: Int = 0
    @State var curentIndex: Int = 0
    
    var width: CGFloat = 250
    var height: CGFloat = 400
    var widthMultiply: CGFloat = 250
    
    var precent: CGFloat {
        let precent: CGFloat = 80
        return (precent * height) / 100
    }
    
    var views: [PosterForFilm]
    
    var body: some View {
        
        let tempIndex = Binding {
            relativeLoc(views)
        } set: {
            self.curentIndex = $0
        }
        VStack {
            ZStack(alignment: .bottom) {
                ForEach(0..<views.count, id: \.self) { item in
                    BigCard(card: views[item])
                        .frame(width: width, height: item == relativeLoc(views) ? height : precent)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .opacity(self.getOpacity(item, views))
                        .offset(x: self.getOffset(item, views))
                        .zIndex(self.getZindex(item, views))
                        .animation(.interpolatingSpring(stiffness: 300.0, damping: 50.0, initialVelocity: 10.0), value: relativeLoc(views))
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onEnded(onDragEnded)
            )
            VStack {
                HStack(spacing: 10) {
                    ForEach(0..<views.count, id: \.self) { item in
                        Indicator(currentIndex: tempIndex, index: item)
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .cornerRadius(12)
            }
            .frame(height: 20)
            .padding(.horizontal, 50)
        }
    }
}


extension InfinityCarousel {
    
    private func relativeLoc(_ arr: [Any]) -> Int {
        ((arr.count * 10000) + carouselLocation) % arr.count
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold: CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            carouselLocation =  carouselLocation + 1
        }
    }
    
    private func getOpacity(_ i: Int, _ arr: [Any]) -> Double {
        let count = arr.count
        switch relativeLoc(arr) {
            case i:
                return 1
            case (i - 2)...(i + 2), ((i - 1) + count), ((i + 1) - count):
                return 0.2
            default:
                return 0
        }
    }
    
    private func getZindex(_ i: Int, _ arr: [Any]) -> Double {
        let count = arr.count
        switch relativeLoc(arr) {
            case i:
                return 2
            case (i - 2)...(i + 2), ((i - 1) + count), ((i + 1) - count):
                return 1
            default:
                return 0
        }
    }
    
    func getOffset(_ i:Int, _ arr: [Any]) -> CGFloat {
        let relative = relativeLoc(arr)
        let count = arr.count
        
        if (i) == relative {
            return self.dragState.translation.width
        } else if (i) == relative + 1 || (relative == count - 1 && i == 0) {
            return self.dragState.translation.width + (widthMultiply + 20)
        } else if
            (i) == relative - 1
                ||
                (relative == 0 && (i) == count - 1) {
            return self.dragState.translation.width - (widthMultiply + 20)
        } else if
            (i) == relative + 2
                ||
                (relative == count - 1 && i == 1)
                ||
                (relative == count - 2 && i == 0) {
            return self.dragState.translation.width + (2 * (widthMultiply + 20))
        } else if
            (i) == relative - 2
                ||
                (relative == 1 && i == count - 1)
                ||
                (relative == 0 && i == count - 2) {
            return self.dragState.translation.width - ( 2 * (widthMultiply + 20))
        } else if
            (i) == relative + 3
                ||
                (relative == count - 1 && i == 2)
                ||
                (relative == count - 2 && i == 1)
                ||
                (relative == count - 3 && i == 0) {
            return self.dragState.translation.width + (3 * (widthMultiply + 20))
        } else if
            (i) == relative - 3
                ||
                (relative == 2 && i == count - 1)
                ||
                (relative == 1 && i == count - 2)
                ||
                (relative == 0 && i == count - 3) {
            return self.dragState.translation.width - (3 * (widthMultiply + 20))
        } else {
            return 10000
        }
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
                case .inactive:
                    return .zero
                case .dragging(let translation):
                    return translation
            }
        }
        var isDragging: Bool {
            switch self {
                case .inactive:
                    return false
                case .dragging:
                    return true
            }
        }
    }
}


struct BigCard: View {
    
    var card: PosterForFilm
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                card.image
                    .resizable()
                    .frame(maxHeight: .infinity)
                HStack {
                    Text(card.title)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color.gray)
            }
        }
    }
}

struct Indicator: View {
    
    @Binding var currentIndex: Int
    var index: Int
    
    var body: some View {
        VStack {
            Circle()
                .fill(currentIndex == index ? Color.gray : Color.gray.opacity(0.35))
                .animation(.linear, value: currentIndex)
        }
    }
}

#if DEBUG
struct InfinityNumber_Previews: PreviewProvider {
    static var previews: some View {
        Carousel()
    }
}
#endif







