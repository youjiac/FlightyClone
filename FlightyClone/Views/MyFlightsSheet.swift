//
//  MyFlightsSheet.swift
//  FlightyClone
//
//  下半部的白色卡片：「My Flights」標題、分享按鈕、頭像，以及航班列表。
//

import SwiftUI

struct MyFlightsSheet: View {
    let flights: [Flight]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 小把手
            Capsule()
                .fill(Theme.hairline)
                .frame(width: 36, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            header
                .padding(.top, 14)
                .padding(.bottom, 6)

            ForEach(flights) { flight in
                FlightRow(flight: flight)
                if let connection = flight.connection {
                    Divider().overlay(Theme.hairline).padding(.leading, 64)
                    ConnectionRow(connection: connection)
                }
                Divider().overlay(Theme.hairline).padding(.leading, 64)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 140)   // 留空間給下面浮起來的 Tab Bar
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 38, topTrailingRadius: 38)
                .fill(Theme.sheet)
                .shadow(color: .black.opacity(0.25), radius: 20, y: -4)
        )
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("My Flights")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Theme.ink)
            Spacer()
            CircleIconButton(symbol: "square.and.arrow.up")
            AvatarView(imageName: "Avatar", size: 46)
        }
    }
}

/// 白色圓形按鈕（可重複利用）
struct CircleIconButton: View {
    let symbol: String
    var size: CGFloat = 46

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Theme.ink)
            .frame(width: size, height: size)
            .background(Theme.sheet, in: Circle())
            .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
    }
}

/// 圓形頭像（可重複利用）：Asset 圖片裁成圓形，背景是蜜桃色
struct AvatarView: View {
    let imageName: String
    var size: CGFloat = 46

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .background(Theme.avatarBG)
            .clipShape(Circle())
    }
}
