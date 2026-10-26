//
//  GlobeMapView.swift
//  FlightyClone
//
//  上半部的衛星地球。用 MapKit 的衛星圖（realistic）縮到很遠，就會變成一顆地球。
//  原版的航線是往北拱起的大弧線，所以我自己算弧線上的點，再用 MapPolyline 連起來。
//  飛行中的那一班用紫色，還沒起飛的用藍色。
//
//  MapKit 的鏡頭拉不了太遠，所以先把地圖畫成 zoom 倍大，再用 scaleEffect 縮回來，
//  同一個距離就能看到更大一塊地球。線寬也乘上 zoom，縮回來才會是正常粗細。
//

import SwiftUI
import MapKit

struct GlobeMapView: View {
    let flights: [Flight]
    /// 地圖先放大幾倍再縮回來
    var zoom: CGFloat = 1.8

    var body: some View {
        GeometryReader { geo in
            map
                .frame(width: geo.size.width * zoom, height: geo.size.height * zoom)
                .scaleEffect(1 / zoom)
                .frame(width: geo.size.width, height: geo.size.height)
        }
        .clipped()
    }

    private var map: some View {
        Map(initialPosition: .camera(MapCamera(
                centerCoordinate: CLLocationCoordinate2D(latitude: 40, longitude: -98),
                distance: 22_000_000, heading: 0, pitch: 0)),
            interactionModes: []) {

            // 航線：飛行中紫色、還沒起飛藍色
            ForEach(flights) { flight in
                MapPolyline(coordinates: arc(from: flight.from.coordinate, to: flight.to.coordinate))
                    .stroke(flight.isInAir ? Theme.past : Theme.route,
                            style: StrokeStyle(lineWidth: 3 * zoom, lineCap: .round, lineJoin: .round))
            }

            // 機場：白框藍點（用 MapCircle 畫，半徑是公尺）
            ForEach(airports, id: \.code) { airport in
                MapCircle(center: airport.coordinate, radius: 190_000)
                    .foregroundStyle(.white)
                MapCircle(center: airport.coordinate, radius: 120_000)
                    .foregroundStyle(Theme.route)
            }
        }
        .mapStyle(.imagery(elevation: .realistic))
    }

    /// 兩個機場之間往北拱起的弧線（原版的樣子）
    private func arc(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        // 經度差取最短的那一邊（東京→舊金山要跨過換日線往東飛）
        var dLon = b.longitude - a.longitude
        if dLon > 180 { dLon -= 360 }
        if dLon < -180 { dLon += 360 }
        let lift = abs(dLon) * 0.16   // 距離越遠拱得越高

        return (0...60).map { i in
            let t = Double(i) / 60
            var lon = a.longitude + dLon * t
            if lon > 180 { lon -= 360 }
            if lon < -180 { lon += 360 }
            let lat = a.latitude + (b.latitude - a.latitude) * t + sin(.pi * t) * lift
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }

    private var airports: [Airport] {
        var seen = Set<String>()
        return flights.flatMap { [$0.from, $0.to] }
            .filter { seen.insert($0.code).inserted && $0.code != "NRT" }
    }
}
