//
//  twoDigitPrime.swift
//  Swift5
//
//  Created by 최윤진 on 2024-08-09.
//

import Foundation

var is_prime = Array(repeating: false, count: 100)
var prefix = Array(repeating: 0, count: 100001)

func preProcessing(){
    for i in [11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]{
        is_prime[i] = true
    }
    
    for i in 1...100000{
        var ns = Array<Int>()
        var chk = 0
        var j = i
        while j != 0{
            ns.append(j % 10)
            j /= 10
        }
        br: for j in 0..<ns.count{
            for k in 0..<ns.count{
                if j == k{
                    continue
                }
                if is_prime[ns[j] * 10 + ns[k]]{
                    chk = 1
                    break br
                }
            }
        }
        prefix[i] = prefix[i - 1] + chk
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("twoDigitPrime.inp")!
        let fout = FileWriter("twoDigitPrime.out")
        var res = ""
        
        preProcessing()
        for _ in 0..<Int(fin.readLine())!{
            let AB = fin.readLine().split(separator: " ").map{Int($0)!}
            res += "\(prefix[AB[1]] - prefix[AB[0] - 1])\n"
        }
        fout.write(res)
    }
}
