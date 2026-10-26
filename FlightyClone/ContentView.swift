//
//  ContentView.swift
//  FlightyClone
//
//  三層疊在一起（ZStack）：
//  1. 最底下：衛星地球＋航線
//  2. 中間：可以往上捲的「My Flights」卡片（ScrollView）
//  3. 最上面：浮起來的 Tab Bar
//

import SwiftUI

struct ContentView: View {
    private let flights = SampleData.flights

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            // 下半部先鋪卡片的顏色，Tab Bar 下面（Home 指示條那塊）才不會露出黑底
            Theme.sheet
                .frame(height: 300)
                .ignoresSafeArea(edges: .bottom)

            GlobeMapView(flights: flights)
                .frame(height: 520)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)

            ScrollView {
                VStack(spacing: 0) {
                    // 透明的空間，讓上面的地球露出來
                    Color.clear.frame(height: 330)
                    MyFlightsSheet(flights: flights)
                }
            }
            .scrollIndicators(.hidden)

            FloatingTabBar()
                .padding(.bottom, 2)
        }
    }
}

#Preview("淺色") {
    ContentView()
}

#Preview("深色") {
    ContentView()
        .preferredColorScheme(.dark)
}
