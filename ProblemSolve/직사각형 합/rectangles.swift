//
//  rectangles.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-07.
//

import Foundation

var ret = Array(repeating: 0, count: 120007)
var cnt = Array(repeating: 0, count: 120007)
var arr = Array<(Int, Int, Int, Int)>()
let compare: ((Int, Int, Int, Int), (Int, Int, Int, Int)) -> Bool = {(a, b) in
    return a < b
}

func f(_ nd: Int,_ l: Int,_ r: Int,_ s: Int,_ e: Int,_ k: Int){
    if r < s || e < l{
        return
    }
    if l <= s && e <= r{
        ret[nd] += k
    }
    else{
        let m = (s + e) / 2
        f(2*nd, l, r, s, m, k)
        f(nd*2+1, l, r, m+1, e, k)
    }
    if ret[nd] != 0{
        cnt[nd] = e - s + 1
    }
    else{
        if s == e{
            cnt[nd] = 0
        }
        else{
            cnt[nd] = cnt[2*nd] + cnt[2*nd+1]
        }
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("rectangles.inp")!
        let fout = FileWriter("rectangles.out")
        
        let n = Int(fin.readLine()!)!
        var py = -1, ans = 0
        for _ in 0..<n{
            let inp = fin.readLine()!.split(separator: " ").map({Int($0)!})
            arr.append((inp[1] + 10000, inp[0] + 10000, inp[2] + 10000, 1))
            arr.append((inp[3] + 10000, inp[0] + 10000, inp[2] + 10000, -1))
        }
        arr.sort(by: compare)
        
        for i in arr{
            let y = i.0, x1 = i.1, x2 = i.2, k = i.3
            
            if py != -1{
                ans += (y - py) * cnt[1]
            }

            f(1, x1 + 1, x2, 1, 20001, k)
            py = y
        }
        fout.write("\(ans)\n")
    }
}
