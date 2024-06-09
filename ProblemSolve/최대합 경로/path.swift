import Foundation

extension ArraySlice where Element: Comparable{
    func lower_util<T: Comparable>(_ As: ArraySlice<T>, _ n: T, _ left: Int, _ right: Int, _ idx: inout Int){
        if left > right {
            return
        }
        
        let mid = (left + right) / 2
        
        if n <= As[mid] && mid < idx{
            idx = mid
        }
        lower_util(As, n, left, mid - 1, &idx)
        lower_util(As, n, mid + 1, right, &idx)
    }
    
    func lower_bound(_ n: Element) -> Int{
        var idx = self.endIndex
        
        lower_util(self, n, self.startIndex , self.endIndex - 1 , &idx)
        
        return idx
    }
}

func Path(_ pre: [Int], _ val: [Int], _ left: Int, _ right: Int, _ res: inout Int) -> Int{
    if left > right {
        return Int.min / 3
    }
    if left == right{
        res = max(res, val[pre[left]])
        return val[pre[left]]
    }
    
    let root = pre[left];
    let root_val = val[pre[left]]
    
    let mid:Int
    let tmp = pre[left + 1...right]

    mid = tmp.lower_bound(root)
    
    
    let left_res = Path(pre, val, left + 1, mid - 1, &res)
    let right_res = Path(pre, val, mid, right, &res)
    
    res = max(res, root_val + left_res + right_res)
    
    return root_val + max(left_res, right_res)
}

@main
struct Main{
    static func main(){
        var RES = "\n"
        let T = Int(readLine()!)!
        for _ in 0..<T{
            let n = Int(readLine()!)!
            let inOrder:[Int] = readLine()!.split(separator: " ").map{Int($0)!}
            let preOrder:[Int] = readLine()!.split(separator: " ").map{Int($0)!}
            
            var res = -10001
            Path(preOrder, inOrder, 0, n - 1, &res)
            RES += String(res) + "\n"
        }
        print(RES)
    }
}
