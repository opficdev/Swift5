//
//  rmq.swift
//  Swift5
//
//  Created by 최윤진 on 2024-06-30.
//

import Foundation

class SegTree{
    private var data: [pair<Int>] = []
    init(_ size: Int){
        self.data = Array(repeating: pair(Int.max, Int.max), count: 4 * size)
    }
    func update(_ idx: Int,_ q: Int,_ ss: Int,_ se: Int,_ val: pair<Int>){
        if ss > q || se < q{
            return
        }
        if q <= ss && se <= q{
            self.data[idx] = val
            return
        }
        
        let mid = (ss + se) / 2
        update(idx * 2, q, ss, mid, val)
        update(idx * 2 + 1, q, mid + 1, se, val)
        
        self.data[idx] = min(data[idx * 2], data[idx * 2 + 1])
    }
    
    func getMin(_ idx: Int,_ qs: Int,_ qe: Int,_ ss: Int,_ se: Int) -> pair<Int>{
        if ss > qe || se < qs{
            return pair(Int.max, Int.max)
        }
        if qs <= ss && se <= qe{
            return data[idx]
        }
        
        let mid = (ss + se) / 2
        return min(
            getMin(idx * 2, qs, qe, ss, mid),
            getMin(idx * 2 + 1, qs, qe, mid + 1, se)
        )
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("rmq.inp")!
        let fout = FileWriter("rmq.out")
        
        let A = Int(fin.readLine()!)!
        let sg = SegTree(A + 1)
        
        let ss = 0, se = A - 1
        
        var endPoint = 0
        while endPoint < A{
            let inp = fin.readLine()!.split(separator: " ").map({Int($0)!})
            for (idx, value) in inp.enumerated(){
                sg.update(1, idx + endPoint, ss, se, pair(value, idx + endPoint))
            }
            endPoint += inp.count
        }
        
        let _ = fin.readLine()
        var sum = 0
        
        while (true){
            let inp = fin.readLine()!.split(separator: " ").map({String($0)})
            let cmd = inp[0], n1 = Int(inp[1])!, n2 = Int(inp[2])!
            
            if cmd == "c"{
                sg.update(1, n1, ss, se, pair(n2, n1))
            }
            else if cmd == "q"{
                sum = (sum + sg.getMin(1, n1, n2, ss, se).second) % 100000
            }
            else{
                fout.write(String(sum % 100000) + "\n")
                break
            }
        }
    }
}
