//
//  queue.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//

import Foundation


///An ordered, non-random-access collection.
struct Queue<Element>{
    private var arr = [Element?]() //  Array to save data
    private var front = 0   //  Point the first element's index
    private var back = 0    //  Point the last element's index
    private var _count = 0   //  Counts of elements
    
    ///Creates a new, empty queue.
    init(){}
    
    ///Creates a queue, containing the elements of a sequence.
    init<S: Sequence>(_ s: S) where S.Element == Element{
        arr = Array(s)
        _count = arr.count
        back = _count - 1
    }
    
    ///Add a new element at the begin of the queue.
    mutating func append(_ newElement: Element){
        if _count == arr.count{
            arr.append(nil)
        }
        
        back = (back + 1) % arr.count
        arr[back] = newElement
        _count += 1
    }
    
    ///Removes and returns the first element of queue.
    @discardableResult  //  @discardableResult: Don't show warning if don't use function's return value
    mutating func removeFirst() -> Element{
        guard let element = popFirst() else{
            fatalError(": Can't remove last element from an empty collection")
        }
        return element
    }
    
    ///Removes all elements from the queue.
    mutating func removeAll(keepingCapacity:Bool = false){
        arr.removeAll(keepingCapacity: keepingCapacity)
        _count = 0
        front = 0
        back = 0
    }
    
    ///Removes and returns the first element of queue.
    @discardableResult
    mutating func popFirst() -> Element?{
        guard _count > 0 else { return nil }
                
        let element = arr[front]
        arr[front] = nil
        
        front = (front + 1) % arr.count
        _count -= 1
        
        if count <= arr.count / 2 && arr.count > 1 {
            arr = Array(arr[front...back])
            front = 0
            back = count - 1
        }
        
        return element
    }
    
    ///The first element of the collection.
    var first: Element?{
        return _count == 0 ? nil : arr[front]
    }
    
    ///The last element of the collection.
    var last: Element?{
        return _count == 0 ? nil : arr[back]
    }
    
    var isEmpty: Bool{
        return arr.isEmpty
    }
    
    var count: Int{
        return _count
    }
    
    var capacity: Int{
        return arr.count
    }
}
