

## ActionSheet

Usage:

```swift
 let action = ActionSheet(frame: self.view.frame)
 action.items = ["Blueberry","Apple","Coconut"]
 action.images = ["Blueberry","Apple","Coconut"]
 action.selectedIndexPath = { indexPath in
     print("\(indexPath)")
 }
 action.showActionSheetWithTitle(title: "SELECT FRUIT", scrollEnable: false)
```
