import Foundation

enum Color{
    case RED
    case BLACK
}

class node{ //internal
    var key: Int = 0
    var left: node? = nil
    var right: node? = nil
    var parent: node? = nil //루트 노드 때문에 nil 포함
    var color = Color.BLACK
    init(){}
}

class RBTree{
    private var root:node? = nil
    private var leafNode: node? = nil
    init(){
        leafNode = node()
        root = leafNode
    }
    
    private func InsertFixUp(_ z: inout node){
        while z !== root && z.parent!.color == Color.RED{ //부모노드의 색이 RED 이므로 무조건 조부 노드가 존재한다
            var grandparent = z.parent!.parent!
            let uncle = z.parent === grandparent.left ? grandparent.right : grandparent.left
            let side: Bool = z.parent === grandparent.left ? true : false
            
            if uncle !== nil && uncle!.color == Color.RED{
                z.parent?.color = Color.BLACK
                uncle!.color = Color.BLACK
                grandparent.color = Color.RED
                z = grandparent
            }
            else{
                if z === (side ? z.parent?.right : z.parent?.left){
                    z = z.parent!
                    side ? RotateLeft(&z) : RotateRight(&z)
                }
                z.parent?.color = Color.BLACK
                grandparent.color = Color.RED
                side ? RotateRight(&grandparent) : RotateLeft(&grandparent)
            }
        }
        root?.color = Color.BLACK
    }
    
    private func tree_minimum(_ x: node) -> node{ //가장 좌측으로 내려가기
        var x = x
        while x.left != nil && x.left !== leafNode{
            x = x.left!
        }
        return x
    }
    
    private func DeleteFixUp(_ x: inout node){
        var s: node
        while (x !== root && x.color == Color.BLACK){ //x가 루트 노드가 아니고 색이 Black인 노드면 x 위에는 무조건 부모노드 있음
            if x === x.parent!.left{
                s = x.parent!.right!
                if s.color == Color.RED{
                    s.color = Color.BLACK
                    x.parent?.color = Color.RED
                    RotateLeft(&x.parent!)
                    s = x.parent!.right!
                }
                if s.left?.color == Color.BLACK && s.right?.color == Color.BLACK{
                    s.color = Color.RED
                    x = x.parent!
                }
                else{
                    if s.right?.color == Color.BLACK{
                        s.left?.color = Color.BLACK
                        s.color = Color.RED
                        RotateRight(&s)
                        s = x.parent!.right!
                    }
                    s.color = x.parent!.color
                    x.parent!.color = Color.BLACK
                    s.right!.color = Color.BLACK
                    RotateLeft(&x.parent!)
                    x = root!
                }
            }
            else{
                s = x.parent!.left!
                if s.color == Color.RED{
                    s.color = Color.BLACK
                    x.parent!.color = Color.RED
                    RotateRight(&x.parent!)
                    s = x.parent!.left!
                }
                if s.left!.color == Color.BLACK && s.right!.color == Color.BLACK{
                    s.color = Color.RED
                    x = x.parent!
                }
                else{
                    if s.left!.color == Color.BLACK{
                        s.right!.color = Color.BLACK
                        s.color = Color.RED
                        RotateLeft(&s)
                        s = x.parent!.left!
                    }
                    s.color = x.parent!.color
                    x.parent!.color = Color.BLACK
                    s.left!.color = Color.BLACK
                    RotateRight(&x.parent!)
                    x = root!
                }
            }
        }
        x.color = Color.BLACK
        root!.color = Color.BLACK
    }
    
    private func Transplant(_ u: inout node, _ v: inout node){
        if u.parent == nil{
            root = v
        }
        else if u === u.parent?.left{
            u.parent?.left = v
        }
        else{
            u.parent?.right = v
        }
        v.parent = u.parent
    }
    
    private func RotateLeft(_ x: inout node){
        let y = x.right
        x.right = y?.left
        if y?.left !== leafNode{
            y?.left?.parent = x
        }
        y?.parent = x.parent
        if (x.parent == nil){
            root = y
        }
        else if x === x.parent?.left{
            x.parent?.left = y
        }
        else{
            x.parent?.right = y
        }
        x.parent = y
        x.parent?.left = x
    }
    
    private func RotateRight(_ y: inout node){
        let x = y.left
        y.left = x?.right
        if x?.right !== leafNode{
            x?.right?.parent = y
        }
        x?.parent = y.parent
        if y.parent == nil{
            root = x
        }
        else if y === y.parent?.left{
            y.parent!.left = x
        }
        else{
            y.parent!.right = x
        }
        y.parent = x
        x?.right = y
    }
    
    func Insert(_ item: Int){
        var x = root, y: node? = nil
        var z = node()
        
        z.key = item
        z.color = Color.RED
        z.left = leafNode
        z.right = leafNode
        
        while x !== leafNode{
            y = x
            if x!.key < item{
                x = x!.right
            }
            else{
                x = x!.left
            }
        }

        z.parent = y
        if y == nil{
            root = z
        }
        else if z.key > y!.key{
            y!.right = z
        }
        else{
            y!.left = z
        }
        
        if z.parent == nil{
            z.color = Color.BLACK
            return
        }
        if z.parent!.parent == nil{
            return
        }
        InsertFixUp(&z)
    }
    
    func Search(_ item: Int) -> node{ //문제에서 존재하는 노드만 검색한다는 조건이 있음
        var t = root
        while t != nil && t!.key != item{
            t = item < t!.key ? t!.left : t!.right
        }
        return t!
    }
    
    func Delete(_ item: Int){
        var z:node? = Search(item)
        var x = node(), y: node
        var OriginalColor = z!.color
        if z!.left === leafNode{
            x = z!.right!
            Transplant(&z!, &z!.right!)
        }
        else if z!.right === leafNode{
            x = z!.left!
            Transplant(&z!, &z!.left!)
        }
        else{
            if z!.right != nil{
                y = tree_minimum(z!.right!)
                OriginalColor = y.color
                x = y.right!
                if y.parent === z{
                    x.parent = y
                }
                else{
                    Transplant(&y, &y.right!)
                    y.right = z!.right
                    y.right?.parent = y
                }
                Transplant(&z!, &y)
                y.left = z!.left
                y.left?.parent = y
                y.color = z!.color
            }
        }
        z = nil
        if OriginalColor == Color.BLACK{
            DeleteFixUp(&x)
        }
    }
}


@main
struct Main{
    static func main(){
        let tree = RBTree()
        var res = ""
        
        let fin = fstream("rbt.inp")!
        let fout = fstream("rbt.out")!
        
        while fin.isEOF{
            let inp = fin.readLine()!.split(separator: " ")
            let cmd = inp[0], data = Int(inp[1])!
            
            if data == -1{
                break
            }
            else if cmd == "i"{
                tree.Insert(data)
            }
            else if cmd == "c"{
                res += "color(\(data)): \(tree.Search(data).color == Color.BLACK ? "BLACK" : "RED")\n"
            }
            else{
                tree.Delete(data)
            }
        }
        fout.write(res)
        
    }
}
