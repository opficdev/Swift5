import Foundation

@main
struct Main{
    static func main(){
        let fin = FileReader("double.inp")!
        let fout = FileWriter("double.out")
        
        var res = ""
        for _ in 0..<Int(fin.readLine()!)!{
            let inp = fin.readLine()!.split(separator: " ").map{String($0)}
            let n = NSDecimalNumber(string: inp[0])
            let op = inp[1]
            let m = NSDecimalNumber(string: inp[2])
            
            if op == "+"{
                res += n.adding(m).stringValue
            }
            else if op == "-"{
                res += n.subtracting(m).stringValue
            }
            else if op == "*"{
                res += n.multiplying(by: m).stringValue
            }
            else{
                let tmp = n.dividing(by: m).stringValue
                
                if tmp.contains("."){
                    let _tmp = tmp[tmp.startIndex..<tmp.firstIndex(of: ".")!]
                    if _tmp == "0" || _tmp == "-0"{
                        res += "0"
                    }
                    else{
                        res += _tmp
                    }
                }
                else{
                    res += tmp
                }
            }
            res += "\n"
        }
        fout.write(res)
    }
}
