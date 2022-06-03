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
        print("downloadImage")
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
                print("downloadImage end")
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
        print("closeKeyboard")
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
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension Color{
    
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return "#" + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return "#" + String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
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
        //let format = DateFormatter()
        
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = form
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
        
        if let date = formatter.date(from: self){
            //print("date end : \(self) -> \(date)")
            return date
        }else{return nil}
    }
    
}

extension Int {
    var withComma: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        f.groupingSize = 3
        return f.string(from: NSNumber(integerLiteral: self)) ?? "\(self)"
    }
}
extension Date {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale   = .current
        return calendar
    }
    func string(_ form: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = form
        return formatter.string(from: self)
    }
    func added(_ com:Calendar.Component,num:Int) -> Date?{
        print("added")
        return Calendar.current.date(byAdding: com, value: num, to: self)
    }
    
    func getUntilDay() -> Date?{
        print("getUntilDay")
        let comp1 = Calendar.current.dateComponents(in: TimeZone.current, from: self)
        let comp2 = DateComponents(calendar: Calendar.current, year: comp1.year, month: comp1.month, day: comp1.day)
        print("getUntilDay end")
        return comp2.date
    }
}

final class ImageContainer: ObservableObject {
    @Published var image = UIImage(systemName: "photo")!

    init(_ url: String?) {
        print("ImageContainer init ")
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
        print("ImageContainer init end")
    }
}

func nowDateStr() -> String{
    print("nowDataStr")
    let now = Date()
    let fromatter = DateFormatter()
    fromatter.dateFormat = "yyyyMMddHHmmssSSSS"
    
    print("nowDataStr end")
    return fromatter.string(from: now)
}

func timeReplace(time: String) -> String{
    print("timeReplace")
    var mTime = time
    mTime = time.replacingOccurrences(of: "/", with: "")
    mTime = time.replacingOccurrences(of: " ", with: "")
    mTime = time.replacingOccurrences(of: ":", with: "")
    mTime = time.replacingOccurrences(of: ".", with: "")
    print("timeReplace end")
    return mTime
}
func getMsec() -> String{
    print("getMsec")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmmssSS", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getMsec　end")
    return timeReplace(time: time)
}
func getSec() -> String{
    print("getSec")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmmss", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getSec end")
    return timeReplace(time: time)
}
func getMinute() -> String{
    print("getMinute")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getMinute")
    return timeReplace(time: time)
}
func getHour() -> String{
    print("getHour")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getHour")
    return timeReplace(time: time)
}
func getDay() -> String{
    print("getDay")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddHH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getDay end")
    return timeReplace(time: time)
}
func getMonth() -> String{
    print("getMonth")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMM", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getMonth end")
    return timeReplace(time: time)
}
func getYear() -> String{
    print("getYear")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getYear end")
    return timeReplace(time: time)
}
func getOnlyMsec() -> String{
    print("getOnlyMsec")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "SS", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyMsec end")
    return timeReplace(time: time)
}
func getOnlySec() -> String{
    print("getOnlySec")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "ss", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlySec end")
    return timeReplace(time: time)
}
func getOnlyMinute() -> String{
    print("getOnlyMinute")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyMinute end")
    return timeReplace(time: time)
}
func getOnlyHour() -> String{
    print("getOnlyHour")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyHour end")
    return timeReplace(time: time)
}
func getOnlyDay() -> String{
    print("getOnlyDay")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyDay end")
    return timeReplace(time: time)
}
func getOnlyMonth() -> String{
    print("getOnlyMonth")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyMonth end")
    return timeReplace(time: time)
}
func getOnlyYear() -> String{
    print("getOnlyYear")
    let format = DateFormatter()
    format.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "ja_JP"))
    let time = format.string(from: Date())
    print("getOnlyYear end")
    return timeReplace(time: time)
}
func getElapsedTime(timeN: String,timeT: String) -> String{
    print("get Elapased time")
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
    print("timeDisassemble")
    let year = Int(time.prefix(4))
    let month = Int(time.prefix(6).suffix(2))
    let day = Int(time.prefix(8).suffix(2))
    let hour = Int(time.prefix(10).suffix(2))
    let minute = Int(time.prefix(12).suffix(2))
    let second = Int(time.prefix(14).suffix(2))
    if year == nil,month == nil,day == nil,hour == nil,minute == nil,second == nil {return nil}
    print("timeDisassemble end")
    return [
        "year" : year ?? 0,
        "month" : month ?? 0,
        "day" : day ?? 0,
        "hour" : hour ?? 0,
        "minute" : minute ?? 0,
        "second" : second ?? 0
    ]
}



func btmOfDay(date: Date) -> Date{
    let calendar: Calendar = Calendar(identifier: .japanese)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

    components.hour = 00
    components.minute = 00
    components.second = 00
    components.nanosecond = 00

    return calendar.date(from: components)!
}
func topOfDay(date: Date) -> Date {
    let calendar: Calendar = Calendar(identifier: .japanese)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    components.hour = 23
    components.minute = 59
    components.second = 59
    components.nanosecond = 59
    
    return calendar.date(from: components)!
}
func resetTime(date: Date) -> Date {
    let calendar: Calendar = Calendar(identifier: .japanese)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

    components.hour = 0
    components.minute = 0
    components.second = 0

    return calendar.date(from: components)!
}

func getIntervalDay(time1: Date, time2: Date) -> Int{
    let retInterval = time1.timeIntervalSince(time2)
    let ret = retInterval/86400

    return Int(floor(ret))
}

func calcDateRemainder(time1: Date, time2: Date?) -> Int{
    
    var retInterval:Double!
    //let firstDateReset = resetTime(date: firstDate)

    if time2 == nil {
        return 0
    } else {
        let secondDateReset: Date = resetTime(date: time2!)
        print(secondDateReset)
        retInterval = time1.timeIntervalSince(secondDateReset)
    }

    let ret = retInterval/86400

    return Int(floor(ret))  // n日
}
func getElapsedTime(time1: Date) -> String{
    var s:Double!
    //let firstDateReset = resetTime(date: firstDate)
   
    s = Date().timeIntervalSince(time1)

    if s < 60 {return "\(Int(floor(s)))秒前"}
    else if s < 3600 {return "\(Int(floor(s/60)))分前"}
    else if s < 86400 {return "\(Int(floor(s/3600)))時間前"}
    else if s < 604800 {return "\(Int(floor(s/86400)))日前"}
    else if s < 2592000 {return "\(Int(floor(s/604800)))週前"}
    else {return time1.string("y年M月")}
}

func getAge(_ barth:Date?) -> Int{
    print("getAge")
    guard let barth = barth else {
        print("getAge end1")
        return 0}
    
    let calendar = Calendar.current
    let birthdate = calendar.dateComponents([.year, .month, .day], from: barth)
    let now = calendar.dateComponents([.year, .month, .day], from: Date())
    let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
    print("getAge end2")
    return ageComponents.year ?? 0
}

func getAge(_ barth:String) -> Int{
    print("getAge")
    guard let date_barth = barth.date("yyyyMMdd") else {
        print("getAge end1")
        return 0
    }
    let calendar = Calendar.current
    let birthdate = calendar.dateComponents([.year, .month, .day], from: date_barth)
    let now = calendar.dateComponents([.year, .month, .day], from: Date())
    let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
    print("getAge end2")
    return ageComponents.year ?? 0
}

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    // Class implementation here...
    func save(_ data: Data, service: String) {
        print("save")
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
        print("save end")
    }
}

let ary_pref = [
    "-","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
    "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
    "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県",
    "愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県",
    "広島県","山口県","徳島県","香川県","愛媛県","高知県",
    "福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"
]


enum EmPicker : Int ,Identifiable,  CaseIterable{
    case picker0 = 0
    case picker1 = 1
    case picker2 = 2
    case picker3 = 3
    case picker4 = 4
    case picker5 = 5
    case picker6 = 6
    case picker7 = 7
    case picker8 = 8
    case picker9 = 9
    case picker10 = 10
    case picker11 = 11
    case picker12 = 12
    case picker13 = 13
    case picker14 = 14
    case picker15 = 15
    case picker16 = 16
    case picker17 = 17
    case picker18 = 18
    case picker19 = 19
    case picker20 = 20
    case picker21 = 21
    case picker22 = 22
    case picker23 = 23
    case picker24 = 24
    case picker25 = 25
    case picker26 = 26
    case picker27 = 27
    case picker28 = 28
    case picker29 = 29
    case picker30 = 30
    case picker31 = 31
    case picker32 = 32
    case picker33 = 33
    case picker34 = 34
    case picker35 = 35
    case picker36 = 36
    case picker37 = 37
    case picker38 = 38
    case picker39 = 39
    case picker40 = 40
    case picker41 = 41
    case picker42 = 42
    case picker43 = 43
    case picker44 = 44
    case picker45 = 45
    case picker46 = 46
    var id: Int { self.rawValue }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
