//
//  Flight.swift
//  FlightyClone
//
//  畫面上的航班資料。航班編號、時間都是示範用的假資料，
//  機場座標是真的，地圖上的航線照真實的大圓航線畫。
//

import CoreLocation

struct Airport {
    let code: String
    let city: String
    let coordinate: CLLocationCoordinate2D

    static let nrt = Airport(code: "NRT", city: "Tokyo", coordinate: .init(latitude: 35.7720, longitude: 140.3929))
    static let sfo = Airport(code: "SFO", city: "San Francisco", coordinate: .init(latitude: 37.6213, longitude: -122.3790))
    static let jfk = Airport(code: "JFK", city: "New York", coordinate: .init(latitude: 40.6413, longitude: -73.7781))
    static let lax = Airport(code: "LAX", city: "Los Angeles", coordinate: .init(latitude: 33.9416, longitude: -118.4085))
}

struct Flight: Identifiable {
    enum Status {
        case inAir(landingIn: String)   // 飛行中：顯示「Landing in 3h 30m」
        case upcoming(date: String)     // 還沒起飛：顯示日期
    }

    let id = UUID()
    let number: String
    let from: Airport
    let to: Airport
    let departure: String
    let arrival: String
    let status: Status
    /// 左邊欄：還有幾天出發
    let countdown: (value: String, unit: String)?
    /// 下一段轉機（例如「55m at NRT」）
    let connection: Connection?

    struct Connection {
        let layover: String
        let airport: String
        let label: String
    }

    var isInAir: Bool {
        if case .inAir = status { return true }
        return false
    }
}

enum SampleData {
    /// 照原版截圖的航班排列：第一班飛行中，後面三班還沒起飛。
    /// 航空公司代碼改成示範用的「FY」，不使用真實航空公司。
    static let flights: [Flight] = [
        Flight(number: "FY 1001", from: .nrt, to: .sfo, departure: "6:10PM", arrival: "11:45AM",
               status: .inAir(landingIn: "3h 30m"), countdown: nil,
               connection: .init(layover: "55m", airport: "JFK", label: "Tight")),
        Flight(number: "FY 1002", from: .sfo, to: .jfk, departure: "12:30PM", arrival: "9:10PM",
               status: .upcoming(date: "Thu, 18 Sep"), countdown: ("14", "DAYS"), connection: nil),
        Flight(number: "FY 1003", from: .jfk, to: .lax, departure: "12:15PM", arrival: "3:00PM",
               status: .upcoming(date: "Thu, 25 Sep"), countdown: ("21", "DAYS"), connection: nil),
        Flight(number: "FY 1004", from: .sfo, to: .jfk, departure: "11:30AM", arrival: "8:20PM",
               status: .upcoming(date: "Mon, 29 Sep"), countdown: ("25", "DAYS"), connection: nil)
    ]
}
