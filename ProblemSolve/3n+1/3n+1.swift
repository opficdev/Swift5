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
        let fin = FileReader("3nplus1.inp")!
        let fout = FileWriter("3nplus1.out")
        
        var res = ""
        while !fin.isEOF{
            max_cnt = 0
            let ab = fin.readLine()!.split(separator: " ").map({Int64($0)!})
            
            let a = ab[0], b = ab[1]
            
            for i in min(a,b)...max(a,b){
                collatx(i)
            }
            res += "\(a) \(b) \(max_cnt)\n"
        }
        fout.write(res)
    }
}
