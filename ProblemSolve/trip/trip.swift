var result = ""

while true{
    let s = Int(readLine()!)!
    if s == 0 { break }
    var money:[Double] = []
    for _ in 0..<s{
        money.append(Double(readLine()!)!)
    }
    let avg = Double(Int(money.reduce(0.0, +) / Double(s)))
    
    result += "\(money.map{ $0 > avg ? 0 : avg - $0 }.reduce(0, +))\n"
}


print(result)
