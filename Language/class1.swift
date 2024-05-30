import Foundation

class Person{
    var id:Int, weight: Double, name: String
    init(){
        self.id = 1
        self.weight = 20.5
        self.name = "Grace"
    }
    init(_ id: Int, _ name: String){
        self.id = id
        self.weight = 20.5
        self.name = name
    }
    init(_ id: Int, _ name: String, _ weight: Double){
        self.id = id
        self.weight = weight
        self.name = name
    }
//    init(_ id: Int = 1, _ name: String = "Grace", _ weight: Double = 20.5){
//        self.id = id
//        self.weight = weight
//        self.name = name
//    }
    func show(){
        print("\(id) \(weight) \(name)")
    }
}

let grace = Person(), ashely = Person(2, "Ashley"), hellen = Person(3, "Hellen", 32.5)
grace.show()
ashely.show()
hellen.show()
