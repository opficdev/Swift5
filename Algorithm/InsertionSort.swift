//InsertionSort

func InsertionSort(_ a:[Int]) -> [Int]{
    var arr = a
    for i in 1..<arr.count{
        let CrtElement = arr[i]
        var j = i - 1
        while (0 <= j && CrtElement < arr[j]){
            arr[j + 1] = arr[j]
            j -= 1
        }
        arr[j+1] = CrtElement
    }
    return arr
}

print(InsertionSort([40,10,50,90,20,80,30,60]))
