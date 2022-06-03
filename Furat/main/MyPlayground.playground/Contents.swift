import UIKit

var greeting = "Hello, playground"

let date = Date()

let formatter: DateFormatter = DateFormatter()
formatter.calendar = Calendar(identifier: .japanese)
formatter.dateFormat = "yyyyMddHHmmssSS"
let str_date = formatter.string(from: date)
let re_date = formatter.date(from: str_date)

let formatter2: DateFormatter = DateFormatter()
formatter2.calendar = Calendar(identifier: .gregorian)
formatter2.dateFormat = "yyyyMddHHmmssSS"
let str_date2 = formatter2.string(from: date)

func topOfDay(date: Date) -> Date {
    let calendar: Calendar = Calendar(identifier: .japanese)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    components.hour = 23
    components.minute = 59
    components.second = 59
    components.nanosecond = 59
    
    return calendar.date(from: components)!
}
let date_top = topOfDay(date: date)
let str_date_top = formatter2.string(from: date_top)

print(date)
print(str_date)
print(str_date2)
print(date_top)
print(str_date_top)

