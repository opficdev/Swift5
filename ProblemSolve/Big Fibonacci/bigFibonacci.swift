import Foundation

func extraDiv(_ n: UInt64) -> UInt64{
    return n % (1000000000 + 7)
}

func multiply(_ N: inout [[UInt64]]){
    for i in 0..<2{
        for j in 0..<2{
            N[i][j] = extraDiv(N[i][j])
        }
    }
    
    let a = N[0][0] * N[0][0] + N[0][1] * N[1][0]
    let b = N[0][0] * N[0][1] + N[0][1] * N[1][1]
    let c = N[1][0] * N[0][0] + N[1][1] * N[1][0]
    let d = N[1][0] * N[0][1] + N[1][1] * N[1][1]
 
    N[0][0] = extraDiv(a)
    N[0][1] = extraDiv(b)
    N[1][0] = extraDiv(c)
    N[1][1] = extraDiv(d)
}

func multiply(_ N: inout [[UInt64]], _ M: inout [[UInt64]]){
    for i in 0..<2{
        for j in 0..<2{
            N[i][j] = extraDiv(N[i][j])
            M[i][j] = extraDiv(M[i][j])
        }
    }
    
    let a = N[0][0] * M[0][0] + N[0][1] * M[1][0]
    let b = N[0][0] * M[0][1] + N[0][1] * M[1][1]
    let c = N[1][0] * M[0][0] + N[1][1] * M[1][0]
    let d = N[1][0] * M[0][1] + N[1][1] * M[1][1]
 
    N[0][0] = extraDiv(a)
    N[0][1] = extraDiv(b)
    N[1][0] = extraDiv(c)
    N[1][1] = extraDiv(d)
}

func power(_ N: inout [[UInt64]], _ n: UInt64){
    if n == 0 || n == 1{
        return
    }
    var M: [[UInt64]] = [
        [1,1], [1, 0]
    ]
    
    power(&N, n / 2)
    multiply(&N)
    
    if n % 2 != 0{
        multiply(&N, &M)
    }
    
}

func fibo(_ n: UInt64) -> UInt64{
    var N: [[UInt64]] = [
        [1,1], [1, 0]
    ]
    if n == 0{
        return 0
    }
    power(&N, n - 1)
    
    return N[0][0]
}

@main
struct Main{
    static func main(){
        let fin = FileReader("bigFibonacci.inp")!
        let fout = FileWriter("bigFibonacci.out")
        
        var res = ""
        let T = Int(fin.readLine()!)!
        for _ in 0..<T{
            let n = UInt64(fin.readLine()!)!
            res += "\(n) \(extraDiv(fibo(n)))\n"
        }
        fout.write(res)
    }
}
