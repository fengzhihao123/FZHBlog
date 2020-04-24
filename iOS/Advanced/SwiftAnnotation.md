## 给函数添加注释说明

Xcode 支持以下几个特殊的文本。
* Parameters ： 描述参数
* Return values ：描述返回值
* Thrown errors ： 描述抛出的错误

应用如下:
```
/**
     function description.
     
     - Parameter name: 名字.
     
     - Returns: 返回一个带有名字的实例
 */
    
func setupAnimalInstance(name: String) -> Animal {
    let animal = Animal()
    animal.name = name
    return animal
}
```

效果可以按住option观看
