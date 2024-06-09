import Foundation

var max_cnt = 0

func collatx(_ n:  Int64){
    var cnt = 1, n = n
    while (n != 1){
        if n & 1 != 0{
            n = 3 * n + 1
        }
        else{
            n >>= 1
        }
        cnt += 1
    }
    max_cnt = max(max_cnt, cnt)
}

@main
struct Main{
    static func main(){
        var res = "\n"
        while true{
            max_cnt = 0
            let ab = readLine()!.split(separator: " ").map{Int64($0)!}
            if (ab.count == 0) {
                break
            }
            let a = ab[0], b = ab[1]
            
            for i in min(a,b)...max(a,b){
                collatx(i)
            }
            res += "\(a) \(b) \(max_cnt)\n"
        }
        print(res)
    }
}
