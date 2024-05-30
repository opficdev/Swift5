func Selection(A:[Int],left:Int, right:Int, k:Int) -> Int{
    let pivot:Int = (left + right) / 2
    var p:Int = left + 1, q:Int = right,arr:[Int] = A
    
    if left == right {
        return arr[left]
    }
    
    arr.swapAt(pivot, left)
    while p <= q{
        while p <= right && arr[p] <= arr[left]{
            p+=1
        }
        while q > left && arr[q] >= arr[left]{
            q-=1
        }
        if p > q{
            break
        }
        arr.swapAt(p, q)
    }
    if 0 <= q && q < arr.count{
        arr.swapAt(left, q)
    }
    let S = q - left //S = [0,~]
    if k <= S {return Selection(A: arr, left: left, right: q - 1, k: k)}
    else if (k == S + 1) {
        return arr[q]
    }
    else {return Selection(A: arr, left: q + 1, right: right, k: k - S - 1)}
}
let A = [6,3,11,9,12,2,8,15,18,10,7,14]
print(A.sorted())
for i in 1...A.count{
    print("\(i)번째 작은 수 : \(Selection(A:A, left: 0, right: A.count - 1, k: i))")
}
