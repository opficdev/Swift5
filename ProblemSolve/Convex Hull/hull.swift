//
//  hull.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-01.
//

import Foundation

struct Point: Comparable{
    var x: Int, y: Int
    init(_ x: Int,_ y: Int){
        self.x = x
        self.y = y
    }
    static func < (p0: Point, p1: Point) -> Bool{
        return p0.x < p1.x || (p0.x == p1.x && p0.y < p1.y)
    }
}

func cross_product(_ O: Point,_ A: Point,_ B: Point) -> Int{
    return (A.x - O.x) * (B.y - O.y)
           - (A.y - O.y) * (B.x - O.x)
}

func convex_hull(_ A: [Point]) -> [Point]{
    let n = A.count
    var k = 0, A = A
    
    if n <= 3{
        return A
    }
    
    var ans:[Point] = Array(repeating: Point(0,0), count: 2 * n)
    A.sort()
    
    for i in 0..<n{
        while k >= 2 && cross_product(ans[k - 2], ans[k - 1], A[i]) <= 0{
            k -= 1
        }
        ans[k] = A[i]
        k += 1
    }
    let t = k + 1
    for i in (1..<n).reversed(){
        while (k >= t && cross_product(ans[k - 2], ans[k - 1], A[i - 1]) <= 0) {k -= 1}
        ans[k] = A[i - 1]
        k += 1
    }
    
    ans = Array(ans[0..<k-1])
    
    return ans
}

@main
struct Main{
    static func main(){
        let fin = FileReader("hull.inp")!
        let fout = FileWriter("hull.out")
        var points:[Point] = []
        
        let n = Int(fin.readLine()!)!
        for _ in 0..<n {
            let xy = fin.readLine()!.split(separator: " ").map({Int($0)!})
            points.append(Point(xy[0], xy[1]))
        }
        let ans = convex_hull(points)
        
        var res = String(ans.count) + "\n"
        for i in ans{
            res += "\(i.x) \(i.y)\n"
        }
        fout.write(res)
    }
}
