//
//  rectangles.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//

import Foundation

func compare(_ l0: [Int64],_ l1: [Int64]) -> Bool{
    return l0[0] + l0[1] < l1[0] + l1[1]
}

func gcd(_ a: Int64,_ b: Int64) -> Int64{
    if b == 0 {
        return a
    }
    return gcd(b, a % b)
}

@main
struct Main{
    static func main(){
        let fin = FileReader("rectangles.inp")!
        let fout = FileWriter("rectangles.out")
        
        let T = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<T{
            var L = Int(fin.readLine()!)! / 2
            var V: [[Int64]] = []
            
            for m in 2...Int64(sqrt(Double(L))){
                let c:Int64 = (m % 2 == 0) ? 1 : 2
                var flag = false
                for n in stride(from: c, to: m, by: 2){
                    if (gcd(m,n) != 1){
                        continue
                    }
                    let v: [Int64] = [m*m - n*n, 2*m*n, m*m + n*n]
                    if (L < v[0] || L < v[1]){
                        flag = true
                        break
                    }
                    V.append(v)
                }
                if flag{
                    break
                }
            }
            V.sort(by: compare)
            
            var count = 0
            for v in V{
                if v[0] + v[1] <= L{
                    L -= Int(v[0] + v[1])
                    count += 1
                }
                else{
                    break
                }
            }
            res += "\(count)\n"
        }
        fout.write(res)
    }
}

