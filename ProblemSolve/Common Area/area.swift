//
//  area.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-07.
//

import Foundation


struct Point{
    var x: Double, y: Double
    init(_ x: Double = 0.0,_ y: Double = 0.0){
        self.x = x
        self.y = y
    }
}

struct Circle{
    var x: Double, y: Double, r: Double
    init(_ arr:[Double]){
        self.x = arr[0]
        self.y = arr[1]
        self.r = arr[2]
    }
}

func getArea(_ p1: Point,_ p2: Point,_ p3: Point) -> Double{
    return 0.5 * abs(p1.x * p2.y + p2.x * p3.y + p3.x * p1.y - p2.x * p1.y - p3.x * p2.y - p1.x * p3.y)
}

func distance(_ c: Circle,_ p: Point) -> Double{
    return sqrt(pow(c.x - p.x, 2.0) + pow(c.y - p.y, 2.0))
}

func getPoints(_ c1: Circle,_ c2: Circle) -> Pair<Point, Point>{
    let d: Double = sqrt(pow(c1.x - c2.x, 2.0) + pow(c1.y - c2.y, 2.0))
    let l: Double = (pow(c1.r, 2.0) - pow(c2.r, 2.0) + pow(d, 2.0)) / (2 * d)
    let h: Double = sqrt(pow(c1.r, 2.0) - pow(l, 2.0));
    
    var p1 = Point(), p2 = Point()
    p1.x = (l / d) * (c2.x - c1.x) + (h / d) * (c2.y - c1.y) + c1.x
    p1.y = (l / d) * (c2.y - c1.y) - (h / d) * (c2.x - c1.x) + c1.y
    
    p2.x = (l / d) * (c2.x - c1.x) - (h / d) * (c2.y - c1.y) + c1.x
    p2.y = (l / d) * (c2.y - c1.y) + (h / d) * (c2.x - c1.x) + c1.y
    
    return Pair(p1, p2)
}

func triangle(_ c1: Circle,_ c2: Circle,_ c3: Circle) -> Double{
    var p1 = Point(), p2 = Point(), p3 = Point()
    let p1p2 = getPoints(c1, c2)
    let p1p3 = getPoints(c1, c3)
    let p2p3 = getPoints(c2, c3)
    
    if distance(c3, p1p2.first!) >= distance(c3, p1p2.second!){
        p3 = p1p2.second!
    }
    else{
        p3 = p1p2.first!
    }
    
    if distance(c2, p1p3.first!) >= distance(c2, p1p3.second!){
        p2 = p1p3.second!
    }
    else{
        p2 = p1p3.first!
    }
    
    if distance(c1, p2p3.first!) >= distance(c1, p2p3.second!){
        p1 = p2p3.second!
    }
    else{
        p1 = p2p3.first!
    }
    
    
    return getArea(p1, p2, p3)
}

@main
struct Main{
    static func main(){
        let fin = FileReader("area.inp")!
        let fout = FileWriter("area.out")
        var res = ""

        let T = Int(fin.readLine()!)!

        for _ in 0..<T{
            var arr = Array<Circle>()
            for _ in 0..<3{
                let inp = fin.readLine()!.split(separator: " ").map({Double($0)!})
                arr.append(Circle(inp))
            }
            res += String(format: "%.2f", triangle(arr[0], arr[1], arr[2])) + "\n"
            let _ = fin.readLine()
        }
        fout.write(res)
    }
}
