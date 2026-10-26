//
//  FloatingTabBar.swift
//  FlightyClone
//
//  底部浮起來的半透明 Tab Bar：Flights、Friends、Passport，右邊獨立一顆搜尋鈕。
//

import SwiftUI

struct FloatingTabBar: View {
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                TabItem(symbol: "airplane", badge: "person.circle.fill", title: "Flights", selected: true)
                TabItem(symbol: "person.2.fill", badge: nil, title: "Friends", selected: false)
                TabItem(symbol: "book.closed.fill", badge: "globe", title: "Passport", selected: false)
            }
            .padding(5)
            .background(.regularMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(Theme.ink)
                .frame(width: 62, height: 62)
                .background(.regularMaterial, in: Circle())
                .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        }
    }
}

/// Tab Bar 的一格（可重複利用）
struct TabItem: View {
    let symbol: String
    /// 疊在右下角的小圖示（原版 Flights 是飛機＋人頭）
    let badge: String?
    let title: String
    let selected: Bool

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .medium))
                .overlay(alignment: .bottomTrailing) {
                    if let badge {
                        Image(systemName: badge)
                            .font(.system(size: 9, weight: .bold))
                            .padding(1)
                            .background(Circle().fill(selected ? Theme.sheet : .clear))
                            .offset(x: 5, y: 3)
                    }
                }
            Text(title)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(selected ? Theme.route : Theme.ink)
        .frame(width: 78, height: 52)
        .background {
            if selected {
                Capsule().fill(Theme.chip.opacity(0.9))
            }
        }
    }
}
