## 面试题 10.01. 合并排序的数组

### 简介
```
给定两个排序后的数组 A 和 B，其中 A 的末端有足够的缓冲空间容纳 B。 编写一个方法，将 B 合并入 A 并排序。

初始化 A 和 B 的元素数量分别为 m 和 n。

示例:

输入:
A = [1,2,3,0,0,0], m = 3
B = [2,5,6],       n = 3

输出: [1,2,2,3,5,6]
说明:

A.length == n + m
```

### 思路
采用双指针，从后往前遍历

### 代码
```
class Solution {
    func merge(_ A: inout [Int], _ m: Int, _ B: [Int], _ n: Int) {
        var pa = m - 1
        var pb = n - 1
        var tail = m + n - 1
        var cur: Int
        
        while pa >= 0 || pb >= 0 {
            if pa == -1 {
                cur = B[pb]
                pb -= 1
            } else if pb == -1 {
                cur = A[pa]
                pa -= 1
            } else if A[pa] > B[pb] {
                cur = A[pa]
                pa -= 1
            } else {
                cur = B[pb]
                pb -= 1
            }
            A[tail] = cur
            tail -= 1
        }
    }
}
```
