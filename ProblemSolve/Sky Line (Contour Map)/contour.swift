//
//  contour.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-04.
//

import Foundation

func createSkyline(_ buildings: [[Int]]) -> [Pair<Int, Int>]{
    let N = buildings.count
    
    var wall: [Pair<Int, Int>] = []
    
    var left: Int, height: Int, right: Int
    
    for i in 0..<N{
        left = buildings[i][0]
        height = buildings[i][1]
        right = buildings[i][2]
        
        wall.append(Pair(left, -height))
        wall.append(Pair(right, height))
    }
    wall.sort()
    
    var skyline: [Pair<Int, Int>] = []
    
    var leftWallHeight = Multiset<Int>(0)
    
    var top = 0
    
    for i in wall{
        if i.second! < 0{
            leftWallHeight.append(-i.second!)
        }
        else{
            leftWallHeight.remove(i.second!)
        }
        
        if leftWallHeight.max! != top{
            top = leftWallHeight.max!
            skyline.append(Pair(i.first!, top))
        }
    }
    
    return skyline
}

@main
struct Main{
    static func main(){
        let fin = FileReader("contour.inp")!
        let fout = FileWriter("contour.out")
        
        
        var i = 1
        var res = ""
        while !fin.isEOF{
            var input:[[Int]] = []
            while true{
                let inp = fin.readLine()!.split(separator: " ").map({Int($0)!})
                if inp.filter({$0 == 0}).count == 3 || inp.isEmpty{
                    let _ = fin.readLine()
                    break
                }
                if inp[2] != 0{
                    input.append(inp)
                }
            }

            let skyline = createSkyline(input)
            
            var det:Int64 = 0
            res += "Test Case #\(i) : "
            if skyline.count > 1{
                for j in 1..<skyline.count{
                    det += Int64(skyline[j-1].second!) * Int64(skyline[j].first! - skyline[j-1].first!)
                    if skyline[j].second! == 0{
                        res += "\(det)"
                        det = 0
                        if j < skyline.count - 1{
                            res += " "
                        }
                        else{
                            res += "\n"
                        }
                    }
                }
            }
            else{
                res += "0\n"
            }
            i += 1
        }
        fout.write(res)
        
    }
}
