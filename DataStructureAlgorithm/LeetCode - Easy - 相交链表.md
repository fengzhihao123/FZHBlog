## 相交链表

### 简介
```
编写一个程序，找到两个单链表相交的起始节点。
```

### 思路
```
双指针

1、pa指向headA，pb 指向headB，两指针每次走一步
2、若pa为nil，则指向headB，若pb为nil，则指向headA
3、若最后两指针的值相同且不为nil，则当前节点为相交节点
```

### 代码
一样的思路，Swift就过不了，Java就能过，也是醉了。

#### Swift
```
class Solution {
    func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        if headA == nil || headB == nil { return nil }
        
        var pa = headA
        var pb = headB
        
        while pa?.val != pb?.val {
            pa = pa == nil ? headB : pa?.next
            pb = pb == nil ? headA : pb?.next
        }
        
        return pa
    }
}
```
#### Java
```
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        ListNode pa = headA;
        ListNode pb = headB;
        
        while (pa != pb) {
            pa = pa == null ? headB : pa.next;
            pb = pb == null ? headA : pb.next;
        }
        return pa;
    }
}
```
