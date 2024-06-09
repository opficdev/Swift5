import Foundation

@main
struct Main{
    static func main(){
        var answer = "\n"
        for _ in 0..<Int(readLine()!)!{
            let inp = readLine()!.split(separator: " ").map{String($0)}
            let n = NSDecimalNumber(string: inp[0])
            let op = inp[1]
            let m = NSDecimalNumber(string: inp[2])
            
            if op == "+"{
                answer += n.adding(m).stringValue
            }
            else if op == "-"{
                answer += n.subtracting(m).stringValue
            }
            else if op == "*"{
                answer += n.multiplying(by: m).stringValue
            }
            else{
                let tmp = n.dividing(by: m).stringValue
                
                if tmp.contains("."){
                    let _tmp = tmp[tmp.startIndex..<tmp.firstIndex(of: ".")!]
                    if _tmp == "0" || _tmp == "-0"{
                        answer += "0"
                    }
                    else{
                        answer += _tmp
                    }
                }
                else{
                    answer += tmp
                }
            }
            answer += "\n"
        }
        print(answer)
    }
}
