import Foundation

extension Int{
    static prefix func ++ (n: inout Int) -> Int{
        n += 1
        return n
    }
    static postfix func ++ (n: inout Int) -> Int{
        let tmp = n
        n += 1
        return tmp
    }
};


@main
struct Main{
    static func main(){
        var n = 1
        ++n
    }
}

