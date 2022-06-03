//
//  Common.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import Foundation
import UIKit
import SwiftUI

enum Error{
    case none
    case uid
    case myself
    case fuser
}

class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil

    func downloadImage(url: String) {

        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
}

struct URLImage: View {

    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()

    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!).resizable()
            }
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension UIColor{
    func setAlpha(alpha a: CGFloat) -> UIColor {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: red, green: green, blue: blue, alpha: a)
    }
}

extension String {
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        return lines
    }
    
    var isNum: Bool {
        return self.range(of: "[0-9]",options: .regularExpression) != nil
    }
    var isSpace: Bool {
        return self.range(of: " ",options: .regularExpression) != nil
    }
    var isRangl: Bool {
        return self.range(of: ">",options: .regularExpression) != nil
    }
    var isAbc: Bool {
        return self.range(of: "[A-Za-z0-9]",options: .regularExpression) != nil
    }
    
    func date(_ form:String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = DateFormatter.dateFormat(fromTemplate: form, options: 0, locale: Locale(identifier: "ja_JP"))
        return format.date(from: self)
    }
}

final class ImageContainer: ObservableObject {
    @Published var image = UIImage(systemName: "photo")!

    init(_ url: String?) {
        // ネットワークから画像データ取得
        let session = URLSession(configuration: .default)
        
        if let urlM = URL(string: url ?? ""){
            let task = session.dataTask(with: urlM, completionHandler: { [weak self] data, _, _ in
                guard let imageData = data,
                    let networkImage = UIImage(data: imageData) else {
                    return
                }

                DispatchQueue.main.async {
                    // 宣言時に@Publishedを付けているので、プロパティを更新すればView側に更新が通知される
                    self?.image = networkImage
                }
                session.invalidateAndCancel()
            })
            task.resume()
        }
    }
}

func nowDateStr() -> String{
    let now = Date()
    let fromatter = DateFormatter()
    fromatter.dateFormat = "yyyyMMddHHmmssSSSS"
    
    return fromatter.string(from: now)
}

func timeReplace(time: String) -> String{
    var mTime = time
    mTime = time.replacingOccurrences(of: "/", with: "")
    mTime = time.replacingOccurrences(of: " ", with: "")
    mTime = time.replacingOccurrences(of: ":", with: "")
    mTime = time.replacingOccurrences(of: ".", with: "")
    return mTime
}
func getMsec() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmmssSS", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getSec() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmmss", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getMinute() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getHour() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getDay() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getMonth() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMM", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getYear() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyMsec() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "SS", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlySec() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "ss", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyMinute() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyHour() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyDay() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyMonth() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getOnlyYear() -> String{
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    return timeReplace(time: time)
}
func getElapsedTime(timeN: String,timeT: String) -> String{
    if timeT == "" || timeT == ""{return ""}
    let arrN: Dictionary<String,Int>? = timeDisassemble(time: timeN)
    let arrT: Dictionary<String,Int>? = timeDisassemble(time: timeT)
    guard arrN != nil && arrT != nil else{return ""}
    
    func getDiff(key: String) -> Int {
        let diff: Int = (arrN![key] ?? 0)  - (arrT![key] ?? 0)
        return diff
    }
    
    let yearDiff: Int = getDiff(key:"year")
    let monthDiff: Int = getDiff(key:"month")
    let dayDiff: Int = getDiff(key:"day")
    let hourDiff: Int = getDiff(key:"hour")
    let minuteDiff: Int = getDiff(key:"minute")
    let secondDiff: Int = getDiff(key:"second")
    
    if yearDiff == 0{
        if monthDiff == 0{
            if dayDiff == 0{
                if hourDiff == 0{
                    if monthDiff == 0 {return "\(secondDiff)秒"}
                    else {return "\(minuteDiff)分"}
                }else {return "\(hourDiff)時間"}
            }else if dayDiff < 7 {return "\(dayDiff)日"}
            else {return "\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
        }else if(monthDiff == 1){
            var mSize:Int = 0
            switch arrT!["month"]{
                case 2:
                    if arrT!["year"]! % 4 == 0 {mSize = 29}
                    else {mSize = 28}
                case 4,6,9,11: mSize = 30
                default : mSize = 31
            }
            let mDay: Int = mSize - arrT!["day"]! + arrN!["day"]!
            if(mDay < 7){return "\(arrT!["day"] ?? 0)日"}
            else {return "\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
        }else {return "\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
    }else if(yearDiff == 1){
        if arrT!["month"] == 12 && arrT!["month"] == 1 {
            if dayDiff == -30 {
                if hourDiff == -23 {
                    if minuteDiff <= -59 {return "\(arrN!["second"] ?? 0)秒"}
                    else {return "\(arrN!["minute"] ?? 0)分"}
                }else {return "\(arrN!["hour"] ?? 0)時間"}
            }else{
                let mDay : Int = 31 - arrT!["day"]! + arrN!["day"]!
                if mDay < 7 {return "\(arrT!["day"] ?? 0)日"}
                else {return "\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
            }
        }else{return "\(arrT!["year"] ?? 0)年\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
    }else {return "\(arrT!["year"] ?? 0)年\(arrT!["month"] ?? 0)月\(arrT!["day"] ?? 0)日"}
}
func timeDisassemble(time: String) -> Dictionary<String,Int>?{
    let year = Int(time.prefix(4))
    let month = Int(time.prefix(6).suffix(2))
    let day = Int(time.prefix(8).suffix(2))
    let hour = Int(time.prefix(10).suffix(2))
    let minute = Int(time.prefix(12).suffix(2))
    let second = Int(time.prefix(14).suffix(2))
    if year == nil,month == nil,day == nil,hour == nil,minute == nil,second == nil {return nil}
    return [
        "year" : year ?? 0,
        "month" : month ?? 0,
        "day" : day ?? 0,
        "hour" : hour ?? 0,
        "minute" : minute ?? 0,
        "second" : second ?? 0
    ]
}

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    // Class implementation here...
    func save(_ data: Data, service: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "chococo",
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
}

let ary_pref = [
    "北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
    "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
    "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県",
    "愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県",
    "広島県","山口県","徳島県","香川県","愛媛県","高知県",
    "福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"
]

enum EmPref : Int ,Identifiable,  CaseIterable{
    case pref0 = 0
    case pref1 = 1
    case pref2 = 2
    case pref3 = 3
    case pref4 = 4
    case pref5 = 5
    case pref6 = 6
    case pref7 = 7
    case pref8 = 8
    case pref9 = 9
    case pref10 = 10
    case pref11 = 11
    case pref12 = 12
    case pref13 = 13
    case pref14 = 14
    case pref15 = 15
    case pref16 = 16
    case pref17 = 17
    case pref18 = 18
    case pref19 = 19
    case pref20 = 20
    case pref21 = 21
    case pref22 = 22
    case pref23 = 23
    case pref24 = 24
    case pref25 = 25
    case pref26 = 26
    case pref27 = 27
    case pref28 = 28
    case pref29 = 29
    case pref30 = 30
    case pref31 = 31
    case pref32 = 32
    case pref33 = 33
    case pref34 = 34
    case pref35 = 35
    case pref36 = 36
    case pref37 = 37
    case pref38 = 38
    case pref39 = 39
    case pref40 = 40
    case pref41 = 41
    case pref42 = 42
    case pref43 = 43
    case pref44 = 44
    case pref45 = 45
    case pref46 = 46
    var id: Int { self.rawValue }
}

