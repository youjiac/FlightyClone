//
//  Theme.swift
//  FlightyClone
//
//  顏色依照 Flighty 原版畫面取樣，淺色／深色模式各一套。
//

import SwiftUI

enum Theme {
    /// 下方卡片（sheet）的底色
    static let sheet     = Color.dynamic(light: .white, dark: UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1))
    static let ink       = Color.dynamic(light: .black, dark: .white)
    static let secondary = Color(red: 0.56, green: 0.56, blue: 0.58)
    static let hairline  = Color.dynamic(light: UIColor(white: 0, alpha: 0.08), dark: UIColor(white: 1, alpha: 0.12))
    static let chip      = Color.dynamic(light: UIColor(white: 0.93, alpha: 1), dark: UIColor(white: 0.22, alpha: 1))

    /// 準點的綠色、緊湊轉機的橘色、航線的藍色、飛過的紫色
    static let onTime = Color(red: 0.13, green: 0.66, blue: 0.36)
    static let tight  = Color(red: 1.00, green: 0.60, blue: 0.00)
    static let route  = Color(red: 0.04, green: 0.48, blue: 1.00)
    static let past   = Color(red: 0.55, green: 0.36, blue: 0.96)

    /// 頭像後面的蜜桃色
    static let avatarBG = Color(red: 1.00, green: 0.84, blue: 0.67)
}

extension Color {
    /// 依照淺色／深色模式自動切換的顏色
    static func dynamic(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}
