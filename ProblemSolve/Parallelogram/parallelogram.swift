//
//  parallelogram.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//

import Foundation

struct Point: Comparable{
    var x: Int, y: Int
    init(_ x: Int,_ y: Int) {
        self.x = x
        self.y = y
    }
    static func < (p0: Point, p1: Point) -> Bool{
        return p0.x < p1.x || (p0.x == p1.x && p0.y < p1.y)
    }
    static func == (p0: Point, p1: Point) -> Bool{
        return p0.x == p1.x && p0.y == p1.y
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

func vecSub(_ p1: Point,_ p2: Point) -> Point{
    return Point(p2.x - p1.x, p2.y - p1.y)
}

@main
struct Main{
    static func main(){
        
        let fin = FileReader("parallelogram.inp")!
        let fout = FileWriter("parallelogram.out")
        
        var res = ""
        while true{
            var points:[Point] = []
            let tmp = fin.readLine()!.split(separator: " ").map({Int($0)!})
            for i in 0..<4{
                points.append(Point(tmp[2 * i], tmp[2 * i + 1]))
            }
            
            if points == Array(repeating: Point(0,0), count: 4){
                break
            }
            
            var pts = convex_hull(points)
            
            while pts.count < 4{
                pts.append(Point(0,0))
            }
            
            if vecSub(pts[0], pts[1]) == vecSub(pts[3], pts[2]){
                res += "1\n"
            }
            else{
                res += "0\n"
            }
        }
        fout.write(res)
    }
}
