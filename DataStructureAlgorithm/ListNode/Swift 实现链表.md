## Swift 实现链表
```
/// L链表
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
    var count = 0
    
    private(set) var first: LinkNode<E>?
    var last: LinkNode<E>? { getNode(at: count - 1) }
    
    var isEmpty: Bool { count == 0 }
    
    subscript(index: Int) -> E {
        get {
            return getNode(at: index).val
        }
        
        set(newValue) {
            let node = getNode(at: index)
            node.val = newValue
        }
    }
    
    // MARK - 添加
    func append(_ newElement: E) {
        let node = LinkNode(newElement, next: nil)
        
        if first == nil {
            first = node
        } else {
            let lastNode = getNode(at: count - 1)
            lastNode.next = node
        }
        count += 1
    }

    func append(contentsOf newElements: [E]) {
        
    }
    
    func insert(_ newElement: E, at i: Int) {
        let node = LinkNode(newElement, next: nil)
        
        if i == 0 {
            node.next = first
            first = node
        } else {
            let preNode = getNode(at: i - 1)
            node.next = preNode.next
            preNode.next = node
        }
        
        count += 1
    }
    
    // MARK - 移除
    
    func remove(_ deleteElement: E) -> E {
        let deleteNode = LinkNode(deleteElement, next: nil)
        
        guard let i = getIndex(deleteNode) else { fatalError("Not Found") }
        let preNode = getNode(at: i)
        preNode.next = deleteNode.next
        count -= 1
        
        return deleteElement
    }
    
    func remove(at i: Int) -> E {
        let removeVal = getNode(at: i).val
        if i == 0 {
            first = first?.next
        } else {
            let preNode = getNode(at: i - 1)
            preNode.next = preNode.next?.next
        }
        
        count -= 1
        return removeVal
    }
    
    func removeFirst() {
        remove(at: 0)
    }
    
    func removeLast() {
        remove(at: count - 1)
    }
    
    func removeAll() {
        first = nil
        count = 0
    }
    
    // MARK - 私有方法
    private func getIndex(_ node: LinkNode<E>) -> Int? {
        let temp = first
        var curIndex = 0
        
        while temp != nil {
            if temp == node {
                return curIndex
            }
            curIndex += 1
        }
        return nil
    }
    
    private func getNode(at i: Int) -> LinkNode<E> {
        if i > count { fatalError("out of Range") }
        var curNode = first
        
        for _ in 0..<i {
            curNode = curNode?.next
        }
        return curNode!
    }
}

extension LinkList {
    func printAllLinkNode() {
        var temp = first
        var elements = [E]()
        
        while temp != nil {
            elements.append(temp!.val)
            temp = temp?.next
        }
        
        print(elements)
    }
}
```
