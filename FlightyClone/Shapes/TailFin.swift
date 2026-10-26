//
//  TailFin.swift
//  FlightyClone
//
//  航空公司的「垂直尾翼」小圖示。原版放的是真實航空公司的標誌，
//  這裡改用自己畫的尾翼形狀（自訂 Shape），不使用任何航空公司商標。
//

import SwiftUI

struct TailFin: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        // 從左下角開始，往右上斜切出一片尾翼
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.45, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.75, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

/// 尾翼標誌（可重複利用）：把 Asset 裡的紅藍塗裝圖片，裁成自訂的尾翼形狀
struct TailFinBadge: View {
    var imageName: String = "FinPaint"
    var size: CGFloat = 14

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size * 0.9, height: size)
            .clipShape(TailFin())
    }
}

#Preview {
    TailFinBadge(size: 60)
}
