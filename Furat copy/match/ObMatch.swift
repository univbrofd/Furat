import Foundation
import SwiftUI
import UIKit
    
class ObMatch:ObservableObject{
    let qey = Query()
    var vw : CGFloat?
    var ary_lover = [String]()
    @Published var ary_lover_rea = [String]()
    var ary_lover_err = [String]()
    @Published var ary2_lover = [[Person]]()

    init(){
        getLover()
    }
    
    func getLover(){
        let data_ary_lover = qey.getLover()
        print("data lover : \(data_ary_lover.count)")
        for info_lover in data_ary_lover{
            guard let id = info_lover["id"] else{
                continue
            }
            let person = Person(id,m_info: info_lover)
            DispatchQueue.global().async {
                self.addLover(person)
            }
        }
    }
    
    func addLover(_ person:Person){
        person.getImges()

        guard person.img1 != nil else {
            print("no img")
            return
        }
        DispatchQueue.main.async {
            self.ary_lover_rea.append(person.id)
        }
    }
    
    func addUser(_ person:Person){
        let id = person.id
        if dic_person.keys.contains(id){
            dic_person[id]?.update(person)
        }else{
            dic_person[id] = person
        }
    }
}
