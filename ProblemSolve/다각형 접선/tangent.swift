//
//  tangent.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//
//  Queue는 Language/Queue.swift에 구현됨

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
var count = 1
func size(_ p0: Point,_ p1: Point) -> Double{
    count += 1
    return Double(pow(Double(p0.x - p1.x), 2.0) + pow(Double(p0.y - p1.y), 2.0))
}

func basic_vec(_ p0: Point,_ p1: Point) -> Pair<Double, Double>{
    let up = Int64(pow(10.0,12.0))
    let a = Double(Int64(p0.x - p1.x) * up ) / sqrt(size(p0, p1))
    let b = Double(Int64(p0.y - p1.y) * up ) / sqrt(size(p0, p1))
    return Pair(a, b)
}

func cross_product(_ O: Point,_ A: Point,_ B: Point) -> Int{
    return (A.x - O.x) * (B.y - O.y)
           - (A.y - O.y) * (B.x - O.x)
}

func atoq(_ arr: [Point]) -> Queue<Point>{
    return Queue(arr)
}

func qtoa(_ que: Queue<Point>) -> [Point]{
    var que = que
    var arr: [Point] = []
    while !que.isEmpty{
        arr.append(que.pop()!)
    }
    return arr
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

func Area(_ arr1: [Point],_ arr2: [Point]) -> Double{ //좌측 다각형 점, 우측 다각형 점
    let hull = convex_hull((arr2 + arr1).reversed()) //컨벡스헐
    
//    var (p1, p2) = (Pair<Point, Point>(), Pair<Point, Point>())
    var p1 = Pair(Point(0,0), Point(0,0))
    var p2 = Pair(Point(0,0), Point(0,0))
    
    for i in 0..<hull.count{
        if i < hull.count - 1{
            if arr1.contains(hull[i]) && arr2.contains(hull[i+1]){
                p1.first = hull[i]
                if i + 1 == hull.count{
                    p1.second = hull[0]
                }
                else{
                    p1.second = hull[i+1]
                }
            }
            else if arr1.contains(hull[i+1]) && arr2.contains(hull[i]){
                p2.first = hull[i]
                if i + 1 == hull.count{
                    p2.second = hull[0]
                }
                else{
                    p2.second = hull[i+1]
                }
            }
        }
        else{
            if arr1.contains(hull[i]) && arr2.contains(hull[0]){
                p1.first = hull[i]
                if i + 1 == hull.count{
                    p1.second = hull[0]
                }
                else{
                    p1.second = hull[i+1]
                }
            }
            else if arr1.contains(hull[0]) && arr2.contains(hull[i]){
                p2.first = hull[i]
                if i + 1 == hull.count{
                    p2.second = hull[0]
                }
                else{
                    p2.second = hull[i+1]
                }
            }
        }
    }
    
    let p1_p2 = basic_vec(p1.first!, p1.second!) //p1의 점에서 출발하고 끝점이 p2의 점인 벡터
    let p2_p1 = basic_vec(p2.first!, p2.second!) //p2의 점에서 출발하고 끝점이 p1의 점인 벡터
    
    var que = atoq(arr1)
    while que.first != p1.first{
        que.append(que.pop()!)
    }
    var arr1 = qtoa(que)
        
    for p in arr1{
        if basic_vec(p, p1.second!) == p1_p2 && size(p, p1.second!) < size(p1.first!, p1.second!){
            p1.first = p
        }
        if basic_vec(p2.first!, p) == p2_p1 && size(p, p2.first!) < size(p2.first!, p2.second!){
            p2.second = p
        }
    }
    
    que = atoq(arr1)
    while(que.first != p1.first){
        que.append(que.pop()!)
    }
    arr1 = qtoa(que)
    
    que = atoq(arr2)
    while(que.first != p2.first){
        que.append(que.pop()!)
    }
    var arr2 = qtoa(que)
    
    for p in arr2{
        if basic_vec(p, p2.second!) == p2_p1 && size(p, p2.second!) < size(p2.first!, p2.second!){
            p2.first = p
        }
        if basic_vec(p1.first!, p) == p1_p2 && size(p, p1.first!) < size(p1.first!, p1.second!){
            p1.second = p
        }
    }
    
    que = atoq(arr2)
    while(que.first != p2.first){
        que.append(que.pop()!)
    }
    arr2 = qtoa(que)
    
    var flag = false
    var (p1_inner, p2_inner) = ([Point](), [Point]())
    for i in 0..<arr1.count{
        if i == 0{
            flag = true
            p1_inner.append(arr1[i])
        }
        else if p2.second == arr1[i]{
            p1_inner.append(arr1[i])
            break
        }
        else if flag{
            p1_inner.append(arr1[i])
        }
    }
    flag = false
    for i in 0..<arr2.count{
        if i == 0{
            flag = true
            p2_inner.append(arr2[i])
        }
        else if p1.second == arr2[i]{
            p2_inner.append(arr2[i])
            break
        }
        else if flag{
            p2_inner.append(arr2[i])
        }
    }
    
    
    var vp:[Point] = []
    if p1.first! == p2.second!{
        vp = (p2_inner + p1_inner).reversed() + [p1.first!]
    }
    else if p1.second! == p2.first!{
        vp = (p1_inner + p2_inner).reversed() + [p1.second!]
    }
    else{
        vp = (p1_inner + p2_inner).reversed()
    }
    
    var area:Double = 0.0
    for i in 0..<vp.count - 1{
        area += Double(cross_product(vp[0], vp[i], vp[i+1])) / 2.0
    }
    
    return area
}

@main
struct Main{
    static func main(){
        for t in 1...10{
//            let fin = FileReader("tangent.inp")!
            let fin = FileReader("\(t).inp")!
            let fout = FileWriter("tangent.out")
            
            let T = Int(fin.readLine()!)!
            var res = ""
            for _ in 0..<T{
                var arr1: [Point] = []
                var n = Int(fin.readLine()!)!
                for _ in 0..<n{
                    let point = fin.readLine()!.split(separator: " ").map({Int($0)!})
                    arr1.append(Point(point[0], point[1]))
                }
                var arr2: [Point] = []
                n = Int(fin.readLine()!)!
                for _ in 0..<n{
                    let point = fin.readLine()!.split(separator: " ").map({Int($0)!})
                    arr2.append(Point(point[0], point[1]))
                }
                
                var area = Area(arr1, arr2)
                if area < 0{
                    area = Area(arr2, arr1)
                }
                res += String(format: "%.1f", area) + "\n";
            }
            fout.write(res)
            
            let t0 = FileReader("\(t).out")!.read()!.replacingOccurrences(of: "\r", with: "")
            let t1 = FileReader("tangent.out")!.read()!
            print(t0 == t1)
        }
    }
}
