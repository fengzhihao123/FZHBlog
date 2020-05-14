## 二叉树的层序遍历
### 题目介绍
```
给你一个二叉树，请你返回其按 层序遍历 得到的节点值。 （即逐层地，从左到右访问所有节点）。
示例：
二叉树：[3,9,20,null,null,15,7],

    3
   / \
  9  20
    /  \
   15   7
返回其层次遍历结果：

[
  [3],
  [9,20],
  [15,7]
]
```
### 解题思路
```
使用队列来实现：
1、将头结点添加到队列
2、判断队列是否为空
  2-1、不为空则访问对头加点
  2-2、再将不为空的左右子结点入队
  2-3、为空则结束循环
```
### 代码实现
```
class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        var queue = [TreeNode?]()
        var res = [[Int]]()
        if root == nil { return res }
        queue.append(root)
        while !queue.isEmpty {
            let curentSize = queue.count
            var nums = [Int]()
            for _ in 0..<curentSize {
                let node = queue.removeFirst()
                nums.append(node!.val)
                if node?.left != nil {
                    queue.append(node?.left)
                }
                if node?.right != nil {
                    queue.append(node?.right)
                }
            }
            res.append(nums)
        }
        return res
    }
}
```
