import Foundation
func BitSize(num:Int) -> Int{
    if (num > 0){
        let bin = String(num,radix: 2)
        return bin.first == "0" ? bin.count : bin.count + 1
    }
    else if (num < 0){
        var bigger:Int = 1
        while (bigger <= -num){
            bigger *= 2
        }
        return String(bigger - num, radix: 2).count
    }
    print("Wrong Input!!")
    return -1;
}

func _2to10(str:String,n:Int) -> Int{
    if (str == String(repeating: "0", count: n)){
        return 0
    }
    else if (str.first! == "0"){
        return Int(str,radix: 2)!
    }
    else{
        return Int(str,radix: 2)! - NSDecimalNumber(decimal: pow(2,n)).intValue
    }
}
func _10to2(int:Int,n:Int) -> String{
    if (int == 0){
        return String(repeating: "0", count: n)
    }
    else if (int > 0){
        let BIN = String(int,radix: 2)
        return String(repeating: "0", count: n - BIN.count) + BIN
    }
    else{
        var bigger:Int = 1
        for _ in 0..<n{
            bigger *= 2
        }
        return String(bigger - int, radix: 2)
    }
}
print("연산자, 피연산자 입력 : ",terminator: "")

let mq = readLine()!.split(separator: " ").map{Int($0)}
var M:Int = mq[0]!, Q:Int = mq[1]!
var n = max(BitSize(num: M),BitSize(num: Q))
let _n:Int = n

var q0:Int = 0, A:Int = 0

while (n > 0){
    if ((Q % 2 == 0 ? "0" : "1") + String(q0) == "01"){
        A += M
    }
    else if ((Q % 2 == 0 ? "0" : "1") + String(q0) == "10"){
        A -= M
    }
    
    var _A:[String] = _10to2(int: A, n: _n).split(separator: "").map{String($0)}
    var _Q:[String] = _10to2(int: Q, n: _n).split(separator: "").map{String($0)}
    
    q0 = Int(_Q.popLast()!)!
    _Q.insert(_A.popLast()!, at: 0)
    _A.insert(_A[0], at: 0)
    
    
    Q = _2to10(str: _Q.joined(), n: _n)
    A = _2to10(str: _A.joined(), n: _n)
    
    n -= 1
}
print(_10to2(int: A, n: _n) + _10to2(int: Q, n: _n))
