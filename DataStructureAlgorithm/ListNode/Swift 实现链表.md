## Swift 实现链表
```
class LinkNode<E: Equatable>: Equatable {
    var val: E
    var next: LinkNode?
    
    init(_ val: E, next: LinkNode?) {
        self.val = val
        self.next = next
    }
    
    static func == (lhs: LinkNode, rhs: LinkNode) -> Bool {
        return lhs.val == rhs.val
    }
}

/*
 参考 API 命名规范：insert(_ newElement: Element, at i: Int)
 */
class LinkList<E: Equatable> {
    var size = 0
    var head: LinkNode<E>?
    
    func append(_ newNode: LinkNode<E>) {
        if head == nil {
            head = newNode
        } else {
            let lastNode = getNode(at: size - 1)
            lastNode.next = newNode
        }
        size += 1
    }
    
    func add(_ newNode: LinkNode<E>, at index: Int) {
        if index == 0 {
            newNode.next = head
            head = newNode
        } else {
            let preNode = getNode(at: index - 1)
            newNode.next = preNode.next
            preNode.next = newNode
        }
        
        size += 1
    }
    
    func remove(_ deleteNode: LinkNode<E>) -> E {
        guard let index = getIndex(deleteNode) else { fatalError("Not Found") }
        let preNode = getNode(at: index)
        preNode.next = deleteNode.next
        size -= 1
        
        return deleteNode.val
    }
    
    func remove(at index: Int) -> E {
        let removeVal = getNode(at: index).val
        
        let preNode = getNode(at: index - 1)
        preNode.next = preNode.next?.next
        size -= 1
        
        return removeVal
    }
    
    func get(at index: Int) -> E {
        return getNode(at: index).val
    }
    
    func set(_ newElement: E, at index: Int) -> E {
        let node = getNode(at: index)
        let old = node.val
        node.val = newElement
        return old
    }
    
    private func getIndex(_ node: LinkNode<E>) -> Int? {
        let temp = head
        var curIndex = 0
        
        while temp != nil {
            if temp == node {
                return curIndex
            }
            curIndex += 1
        }
        return nil
    }
    
    private func getNode(at index: Int) -> LinkNode<E> {
        if index > size { fatalError("out of range") }
        var curNode = head
        
        for _ in 0..<index {
            curNode = curNode?.next
        }
        return curNode!
    }
    
    func clear() {
        head = nil
        size = 0
    }
}

extension LinkList {
    func printAllLinkNode() {
        var temp = head
        var elements = [E]()
        
        while temp != nil {
            elements.append(temp!.val)
            temp = temp?.next
        }
        
        print(elements)
    }
}


let link1 = LinkList<String>()
link1.append(LinkNode("1", next: nil))
link1.append(LinkNode("2", next: nil))
link1.append(LinkNode("3", next: nil))
link1.printAllLinkNode()
link1.remove(at: 2)
link1.printAllLinkNode()
```