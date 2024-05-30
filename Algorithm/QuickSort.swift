func QuickSort(A:[Int],left:Int, right:Int) -> [Int]{
    let pivot:Int = (left + right) / 2
    var p:Int = left + 1, q:Int = right,arr:[Int] = A
    
    if left < right{
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
        if 0 <= q {
            arr.swapAt(left, q)
        }
        arr = QuickSort(A: arr, left: left, right: q - 1)
        arr = QuickSort(A: arr, left: q + 1, right: right)
    }
    return arr
}

var A:[Int] = []
for i in 0...999{
    A.append(i)
}
for _ in 0...999{
    if QuickSort(A: A.shuffled(), left: 0, right: A.count - 1) != A{
        print("False")
        break
    }
}
