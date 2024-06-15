//
//  ContentView.swift
//  ShimmerGen
//
//  Created by Jamie Chu on 6/14/24.
//

import SwiftUI
//var data = [
//    "Beatles",
//    "Pearl Jam",
//    "REM",
//    "Guns n Roses",
//    "Red Hot Chili Peppers",
//    "No Doubt",
//    "Nirvana",
//    "Tom Petty and the Heart Breakers",
//    "The Eagles"
//
//]

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometryProxy in
            List(viewModel.generated, id: \.self) { element in
                switch element {
                case .flexibleViews(let data, let spacing):
                    FlexibleView(
                        availableWidth: geometryProxy.size.width, data: data,
                        spacing: spacing,
                        alignment: .leading
                    ) { item in
                        Text(item)
                            .padding(4)
                            .opacity(.zero)
                            .background {
                                Capsule()
                                    .fill(colorGen.run())
                            }                        
                    }
                    .padding()
                    .frame(width: geometryProxy.size.width, alignment: .leading)
                    
                case .caseRedactedText(let text):
                    Text(text)
                        .redacted(reason: .placeholder)
                    
                case let .styledImages(images):
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Image(systemName: image.systemImageName)
                                .font(image.font)
                                .foregroundColor(image.color)
                        }
                        
                        Spacer()
                    }
                }
                
                if element != viewModel.generated.last {
                    Rectangle()
                        .frame(width: geometryProxy.size.width, height: 2)
                        .foregroundColor(colorGen.run().darker())
                }
            }
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.onRefreshPulled()
            }
            .padding(.zero)
            .shimmering()
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

#Preview {
    ScrollView {
        ContentView(viewModel: .init())
    }
}

final class ViewModel: ObservableObject {
    @Published var generated: [Generated] = []
    
    func onAppear() {
        if generated.isEmpty {
            reHydrate()
        }
    }

    func onRefreshPulled() {
        reHydrate()
    }
    
    private func reHydrate() {
        generated = temp.array(of: .always(12)).run()
    }
}

// something that can be changed into a view easily
enum Generated: Hashable {
    struct StyledImage: Hashable {
        let font: Font
        let systemImageName: String
        let color: Color
    }
    
    case styledImages([StyledImage])
    case caseRedactedText(String)
    case flexibleViews(_ data: [String], _ spacing: CGFloat)
}


extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
