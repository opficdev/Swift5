import Foundation
//Xcode 빌드 시 fileIO.swift가 있어야 함

func Dish(_ str: String) -> String{
    var start = str.first!
    var width = 10
    for i in 1..<str.count{
        if start == str[str.index(str.startIndex, offsetBy: i)]{
            width += 5
        }
        else{
            width += 10
        }
        start = str[str.index(str.startIndex, offsetBy: i)]
    }
    return String(width)
}

@main
struct Main{
    static func main(){
        let fin = fstream("dish.inp")!
        let fout = fstream("dish.out")!
        
        let T = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<T{
            let _ = Int(fin.readLine()!)!
            let dish = fin.readLine()!
            res += Dish(dish) + "\n"
        }
        fout.write(res)
    }
}
