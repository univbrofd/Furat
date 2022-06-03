import SwiftUI

struct VwMypageCrft: View {
    @EnvironmentObject var spr:Spr
    var body: some View {
        VStack{
            if let img1 = spr.myself?.img1{
                Image(uiImage: img1)
            }
            HStack{
                if let icon = spr.myself?.icon{
                    Image(uiImage: icon)
                }
                Text(spr.myself?.name ?? "未設定")
                Text(String(spr.myself?.age ?? 0))
                Text(spr.myself?.pref ?? "未設定")
            }
        }
    }
}
