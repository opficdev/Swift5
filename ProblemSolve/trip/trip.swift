import Foundation

@main
struct Main{
    static func main(){
        var res = ""
        let fin = FileReader("trip.inp")!
        let fout = FileWriter("trip.out")
        
        while true{
            let s = Int(fin.readLine()!)!
            if s == 0 { break }
            
            var money:[Double] = []
            
            var sum = 0.0
            for _ in 0..<s{
                money.append(Double(fin.readLine()!)!)
                sum += money.last!
            }
            
            let avg = sum / Double(s)
            
            var posSum = 0.0, negSum = 0.0
            
            for i in money{
                let diff = Double(Int((i - avg) * 100)) / 100.0
                if diff >= 0 {
                    posSum += diff
                }
                else {
                    negSum -= diff
                }
            }
            
            res += String(format: "$%.2f", max(posSum, negSum)) + "\n"
            
        }
        fout.write(res)
    }
}

