//
//  PriorityQueue.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-05.
//

import Foundation

struct PriorityQueue<T1: Comparable>{
    struct Heap<T2> {
        private var elements: [T2] = []
        private let comparator: (T2, T2) -> Bool
        
        init(comparator: @escaping (T2, T2) -> Bool){
            self.comparator = comparator
        }
        
        init(_ element: T2, comparator: @escaping (T2, T2) -> Bool){
            self.elements = [element]
            self.comparator = comparator
        }
        
        init(_ elements: [T2], comparator: @escaping (T2, T2) -> Bool) {
            self.elements = elements
            self.comparator = comparator
            buildHeap()
        }
        
        var isEmpty: Bool {
            return elements.isEmpty
        }
        
        var count: Int {
            return elements.count
        }
        
        var top: T2? {
            return elements.first
        }
        
        mutating func append(_ element: T2) {
            elements.append(element)
            siftUp(from: elements.count - 1)
        }
        
        mutating func remove() {
            if !isEmpty{
                elements.swapAt(0, count - 1)
                elements.removeLast()
                if !isEmpty {
                    siftDown(from: 0)
                }
            }
        }
        
        mutating func pop() -> T2? {
            guard !isEmpty else { return nil }
            elements.swapAt(0, count - 1)
            let result = elements.removeLast()
            if !isEmpty {
                siftDown(from: 0)
            }
            return result
        }
        
        private mutating func buildHeap() {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i)
            }
        }
        
        private mutating func siftUp(from index: Int) {
            var child = index
            var parent = parentIndex(of: child)
            while child > 0 && comparator(elements[parent], elements[child]) {
                elements.swapAt(child, parent)
                child = parent
                parent = parentIndex(of: child)
            }
        }
        
        private mutating func siftDown(from index: Int) {
            var parent = index
            while true {
                let leftChild = leftChildIndex(of: parent)
                let rightChild = rightChildIndex(of: parent)
                var candidate = parent
                
                if leftChild < count && comparator(elements[candidate], elements[leftChild]) {
                    candidate = leftChild
                }
                if rightChild < count && comparator(elements[candidate], elements[rightChild]) {
                    candidate = rightChild
                }
                if candidate == parent {
                    return
                }
                elements.swapAt(parent, candidate)
                parent = candidate
            }
        }
        
        private func parentIndex(of index: Int) -> Int {
            return (index - 1) / 2
        }
        
        private func leftChildIndex(of index: Int) -> Int {
            return 2 * index + 1
        }
        
        private func rightChildIndex(of index: Int) -> Int {
            return 2 * index + 2
        }
    }

    private var heap: Heap<T1>
    
    init(by: @escaping (T1, T1) -> Bool = (<)){
        self.heap = Heap(comparator: by)
    }
    
    init(_ data: T1, by: @escaping (T1, T1) -> Bool = (<)){
        self.heap = Heap(data, comparator: by)
    }
    
    init(_ data: [T1], by: @escaping (T1, T1) -> Bool = (<)){
        self.heap = Heap(data, comparator: by)
    }
    
    var top: T1?{
        return self.heap.top
    }
    
    var isEmpty: Bool{
        return self.heap.isEmpty
    }
    
    var count: Int{
        return self.heap.count
    }
    
    mutating func append(_ newElement: T1){
        self.heap.append(newElement)
    }
    
    mutating func remove(){
        self.heap.remove()
    }
    
    mutating func pop() -> T1?{
        return self.heap.pop()
    }
}

