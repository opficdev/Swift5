//
//  cycle.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//

import Foundation

var sum = 0
var cycleArr:[Int] = []
var tmpArr:[Int] = []

func Cycle(_ i: Int){
    tmpArr[i] = 1
    if tmpArr[cycleArr[i]] == 1{
        sum += 1
    }
    else{
        Cycle(cycleArr[i])
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("cycle.inp")!
        let fout = FileWriter("cycle.out")
        
        var T = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<T{
            let size: Int = Int(fin.readLine()!)!
            cycleArr = fin.readLine()!.split(separator: " ").map({Int($0)! - 1})
            tmpArr = Array(repeating: 0, count: size)
            
            for i in 0..<size{
                if tmpArr[i] == 0{
                    Cycle(i)
                }
            }
            res += "\(sum)\n"
            sum = 0
        }
        fout.write(res)
    }
}
