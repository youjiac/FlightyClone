# Flighty 模仿 FlightyClone

> 彼得潘的 iOS App 程式設計 #03・模仿 App Store 上架的 App，製作一頁精美的 App 畫面

模仿對象：**[Flighty – Live Flight Tracker](https://apps.apple.com/app/id1358823008)** 的「My Flights」畫面。

| 原版 Flighty | 我的版本 | 我的版本（深色） |
|---|---|---|
| <img src="pic/original.png" width="250"> | <img src="pic/mine.png" width="250"> | <img src="pic/mine_dark.png" width="250"> |

---

## 為什麼選 Flighty

Flighty 拿過 2023 年的 Apple 設計大獎，是公認畫面最漂亮的航班 App 之一。它的「My Flights」畫面只有一頁，卻同時有：

- 一顆可以看到航線的衛星地球
- 一張從下面浮上來的圓角卡片
- 很細的資訊層次：航班號、城市、起降時間、狀態顏色、轉機提醒
- iOS 26 風格、浮在畫面上的半透明 Tab Bar

要把它做得像，得把 ZStack、ScrollView、自訂 View 都用上。

## 畫面拆解

```
ZStack
├── GlobeMapView        衛星地球＋大圓航線（MapKit）
├── ScrollView
│   ├── 透明空間        讓地球露出來
│   └── MyFlightsSheet  白色圓角卡片
│       ├── 標題列      My Flights＋分享鈕＋頭像
│       └── FlightRow × 5
│           ├── LeftGutter   IN AIR／倒數
│           ├── TailFinBadge＋航班號＋狀態
│           ├── 城市 to 城市
│           └── TimeChip × 2 起飛／降落
└── FloatingTabBar      Flights／Friends／Passport＋搜尋
```

## 幾個做得像的細節

- **地球是真的**：MapKit 的 `.imagery(elevation: .realistic)` 縮到 2,200 萬公尺高、對準北美，就會變成一顆 3D 地球。
- **航線是拱起來的**：原版的航線往北拱成大弧線，我自己算 61 個點（中間用 `sin` 往上抬），再用 `MapPolyline` 連起來。
- **拉遠看到整顆地球**：MapKit 鏡頭拉不遠，所以先把地圖畫成 1.8 倍大，再用 `scaleEffect` 縮回來。
- **航線分兩種顏色**：飛行中的東京→舊金山用紫色，還沒起飛的用藍色，跟原版截圖一樣。
- **顏色照原版取樣**：準點綠、緊湊轉機橘、航線藍、飛行中的紫。
- **「城市 to 城市」**：兩個城市名加粗，中間的 to 不加粗，用 `Text + Text` 拼起來。
- **尾翼標誌**：原版是航空公司的標誌，我改用自己畫的尾翼形狀（`TailFin` 自訂 Shape），不使用任何航空公司商標。航班編號、時間都是示範用的假資料。

## 作業要求對照

| 要求 | 做法 |
|---|---|
| VStack / HStack / ZStack / Text / Image / ScrollView | 整個畫面是 ZStack 三層；卡片在 ScrollView 裡可以往上捲 |
| Asset 圖片 | 頭像 `Avatar`、尾翼塗裝 `FinPaint`、App Icon |
| SF Symbol | 飛機、箭頭、跑步的人、Tab Bar 圖示、搜尋 |
| 多個 modifier | 圓角、陰影、半透明材質、裁切、字重、顏色 |
| 多個檔案定義 view | `Views/` 底下 5 個檔案，另有 `Model/`、`Shapes/` |
| 用 property 客製可重複利用的 view | `FlightRow`、`TimeChip`、`LeftGutter`、`ConnectionRow`、`TabItem`、`CircleIconButton`、`AvatarView`、`TailFinBadge` |
| ⭐ 淺色／深色 | 卡片、文字顏色都跟著系統切換 |
| ⭐ 地圖 | MapKit 衛星地球＋`MapPolyline` 弧線＋`MapCircle` 機場 |
| ⭐ Markdown 連結 | 轉機列的「Tight」是 `[Tight](https://flighty.com)`，用 `.tint` 保持橘色 |
| ⭐ 圖片裁成自訂形狀 | 尾翼塗裝圖片用 `.clipShape(TailFin())` 裁成自己畫的尾翼 |

## 專案結構

```
FlightyClone/
├── FlightyCloneApp.swift
├── ContentView.swift          ← ZStack 三層
├── Model/Flight.swift         ← 機場座標、示範航班
├── Shapes/TailFin.swift       ← 自訂尾翼形狀
└── Views/
    ├── Theme.swift            ← 取樣的顏色
    ├── GlobeMapView.swift     ← 地球＋大圓航線
    ├── MyFlightsSheet.swift   ← 卡片、標題列、頭像
    ├── FlightRow.swift        ← 航班列、時間、轉機
    └── FloatingTabBar.swift   ← 浮動 Tab Bar
```
