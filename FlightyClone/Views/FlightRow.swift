//
//  FlightRow.swift
//  FlightyClone
//
//  一班航班（可重複利用的自訂 View，用 property 傳入航班資料）。
//  版面照原版：左邊狀態欄、尾翼＋航班號、「城市 to 城市」、起降時間。
//

import SwiftUI

struct FlightRow: View {
    let flight: Flight

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            LeftGutter(flight: flight)
                .frame(width: 52)

            VStack(alignment: .leading, spacing: 5) {
                // 第一行：尾翼＋航班號，右邊是狀態
                HStack(alignment: .firstTextBaseline) {
                    HStack(spacing: 6) {
                        TailFinBadge(size: 13)
                        Text(flight.number)
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.secondary)
                    }
                    Spacer()
                    statusText
                }

                // 第二行：城市 to 城市
                (Text(flight.from.city).fontWeight(.semibold)
                 + Text(" to ").foregroundColor(Theme.ink.opacity(0.85))
                 + Text(flight.to.city).fontWeight(.semibold))
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                // 第三行：起飛、降落時間
                HStack(spacing: 16) {
                    TimeChip(isDeparture: true, code: flight.from.code, time: flight.departure, live: flight.isInAir)
                    TimeChip(isDeparture: false, code: flight.to.code, time: flight.arrival, live: flight.isInAir)
                }
                .padding(.top, 1)
            }
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder private var statusText: some View {
        switch flight.status {
        case .inAir(let landingIn):
            (Text("Landing in ").foregroundColor(Theme.secondary)
             + Text(landingIn).foregroundColor(Theme.onTime))
                .font(.system(size: 15))
        case .upcoming(let date):
            Text(date)
                .font(.system(size: 15))
                .foregroundStyle(Theme.secondary)
        }
    }
}

/// 左邊的狀態欄：飛行中顯示飛機圖示，還沒起飛顯示倒數
struct LeftGutter: View {
    let flight: Flight

    var body: some View {
        VStack(spacing: 4) {
            if flight.isInAir {
                ZStack {
                    Circle()
                        .fill(Theme.chip)
                        .frame(width: 40, height: 40)
                    Image(systemName: "airplane.arrival")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.secondary)
                }
                Text("IN AIR")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.secondary)
            } else if let countdown = flight.countdown {
                Text(countdown.value)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(countdown.unit)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.secondary)
            }
        }
        .padding(.top, 4)
    }
}

/// 起飛／降落時間（可重複利用）：圓形箭頭＋機場代碼＋時間
struct TimeChip: View {
    let isDeparture: Bool
    let code: String
    let time: String
    /// 飛行中的航班用綠色，其他用灰色
    let live: Bool

    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(live ? Theme.onTime : Theme.secondary.opacity(0.55))
                    .frame(width: 19, height: 19)
                Image(systemName: isDeparture ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(.white)
            }
            Text(code)
                .font(.system(size: 17))
                .foregroundStyle(Theme.secondary)
            Text(time)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(live ? Theme.onTime : Theme.ink)
        }
    }
}

/// 轉機提醒：「55m at NRT」＋右邊的「Tight」
struct ConnectionRow: View {
    let connection: Flight.Connection

    var body: some View {
        HStack {
            (Text(connection.layover).fontWeight(.semibold).foregroundColor(Theme.tight)
             + Text(" at \(connection.airport)").foregroundColor(Theme.secondary))
                .font(.system(size: 15))
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "figure.run")
                // Markdown 連結：點「Tight」會開轉機說明，顏色用 tint 維持原版的橘色
                Text(.init("[\(connection.label)](https://flighty.com)"))
                    .fontWeight(.semibold)
                    .tint(Theme.tight)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.secondary)
            }
            .font(.system(size: 15))
            .foregroundStyle(Theme.tight)
        }
        .padding(.leading, 64)
        .padding(.vertical, 8)
    }
}
