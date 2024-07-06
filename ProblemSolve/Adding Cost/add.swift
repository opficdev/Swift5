//
//  add.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-05.
//

import Foundation

@main
struct Main{
    static func main(){
        let fin = FileReader("add.inp")!
        let fout = FileWriter("add.out")
        var res = ""
    
        while true{
            let N = Int(fin.readLine()!)!
            if N == 0{
                break
            }
            var pq = PriorityQueue(fin.readLine()!.split(separator: " ").map({UInt64($0)!}), by:>)
            var total: UInt64 = 0
            while pq.count > 1{
                let n1 = pq.pop()!, n2 = pq.pop()!
                total += n1 + n2
                pq.append(n1 + n2)
            }
            res += "\(total)\n"
        }
        fout.write(res)
    }
}

