import Foundation

func nCr(_ num1: Int, _ num2: Int) -> Int{ return (1...(num1 + num2)).reduce(1, *) / ((1...num1).reduce(1, *) * (1...num2).reduce(1, *)) }

//특정 점을 꼭 한번씩 지나가야 하는 경우
func mustPass(){
    var answer = 1
    var dots = dots.sorted(by: {$0[0] < $1[0] || ($0[0] == $1[0] && $0[1] < $1[1])})
    dots.append([y-1, x-1])
    
    var xy:[Int] = [0,0]
    for i in dots{
        let _x = i[0] - xy[0], _y = i[1] - xy[1]
        answer *= nCr(_x, _y)
        xy = i
    }
    
    print("mustPass : \(answer)")
}

//특정 점을 지나면 안되는 경우
func mustnotPass(){
    var table:[[Int]] = Array(repeating: Array(repeating: 1, count: y), count: x)
    for i in dots{
        let _x = i[1], _y = i[0]
        if _x >= x || _y >= y { continue }
        table[_x][_y] = 0
    }
    for i in 0..<y{
        for j in 0..<x{
            if table[j][i] != 0 && i > 0 && j > 0{
                table[j][i] = table[j-1][i] + table[j][i-1]
            }
            else if i == 0 && j > 0{
                if table[j-1][i] == 0{
                    table[j][i] = 0
                }
            }
            else if i > 0 && j == 0{
                if table[j][i-1] == 0{
                    table[j][i] = 0
                }
            }
        }
    }
    print("mustnotPass : \(table.last!.last!)")
}

let d = Int(readLine()!)!
var dots:[[Int]] = []

let xy:[Int] = readLine()!.split(separator: " ").map{Int($0)!}
let x:Int = xy[1], y:Int = xy[0]


for _ in 0..<d{
    dots.append(readLine()!.split(separator: " ").map{Int($0)!}) //점 입력은 인덱스번호 형태
}
mustPass()
mustnotPass()
