import Foundation

let Tmap:Dictionary<String, Int> = [
    "S": 0, "H": 1, "D": 2, "C": 3
]

let Nmap:Dictionary<String, [Int]> = [
    "A": [1,14], "1": [1, 14], "2": [2], "3": [3], "4": [4],
    "5": [5], "6": [6], "7": [7], "8": [8] ,"9": [9],
    "T": [10], "J": [11], "Q": [12], "K": [13]
]

func isFlush(_ map: Dictionary<String, Int>) -> Bool{
    var tmp:[Int] = []
    for m in map.values{
        tmp.append(m)
    }
    let max:Int = tmp.max()!
    return max >= 5
}

func isStraight(_ arr: [Int]) -> Bool{
    for i in 0..<10{
        let tmp: [Int] = Array(arr[i..<i + 5])
        if !tmp.contains(0){
            return true
        }
    }
    return false
}

func findPairs(_ arr1: [Int], _ arr2: [[Bool]], _ j: Int, _ k: Int) -> Bool {
    let count = arr1[0..<arr1.count - 1].filter{ $0 >= j }.count
    return count >= k
}

func isStraightFlush(_ arr: [Int], _ Arr: [[Bool]]) -> Bool {
    for i in 0..<10{
        let tmp1: [Int] = Array(arr[i..<i + 5])
        if !tmp1.contains(0){
            for j in 0..<4{
                let tmp2: [Bool] = Array(Arr[j][i..<i + 5])
                if !tmp2.contains(false){
                    return true;
                }
            }
        }
    }
    return false;
}


@main
struct Main{
    static func main(){
        let fin = FileReader("poker.inp")!
        let fout = FileWriter("poker.out")
        
        var res = ""
        let T = Int(fin.readLine()!)!
        for _ in 0..<T{
            var Arr: [[Bool]] = Array(repeating: Array(repeating: false, count: 14), count: 4)
            var tTmap: Dictionary<String, Int> = [
                "S": 0, "D": 0, "H": 0, "C": 0
            ]
            var arr: [Int] = Array(repeating: 0, count: 14)
            
            let TN: [String] = fin.readLine()!.split(separator: " ").map{ String($0) }
            for tn in TN{
                let t: String = String(tn[tn.startIndex]), n: String = String(tn[tn.index(after: tn.startIndex)])
                tTmap[t]! += 1
                for _n in Nmap[n]!{
                    Arr[Tmap[t]!][_n - 1] = true
                }
            }
            
            for i in 0..<4{
                for j in 0..<14{
                    if (Arr[i][j]){
                        arr[j] += 1
                    }
                }
            }
            
            
            if (isStraightFlush(arr, Arr)){
                res += "Straight Flush\n"
            }
            else if (findPairs(arr, Arr, 4, 1)){
                res += "Four Card\n"
            }
            else if (findPairs(arr, Arr, 3, 1) && findPairs(arr, Arr, 2, 2)){
                res += "Full House\n"
            }
            else if (isFlush(tTmap)){
                res += "Flush\n"
            }
            else if (isStraight(arr)){
                res += "Straight\n"
            }
            else if (findPairs(arr, Arr, 3, 1)){
                res += "Triple\n"
            }
            else if (findPairs(arr, Arr, 2, 2)){
                res += "Two Pair\n"
            }
            else if (findPairs(arr, Arr, 2, 1)){
                res += "One Pair\n"
            }
            else{
                res += "Top\n"
            }
        }
        fout.write(res)
    }
}
