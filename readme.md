SRSTreeView
========
Swift / iOS.  This is UIScrollview based class that creates a tree view that performs like UITableView.

Features
========
All tree view cells have an icon and a label.  If its a parent row, then it will also have a disclosure indicator arrow (Right or Down) to tell the user if the tree view is expanded or not.

What you need
---
Really all you need is to include the 
SRSTreeViewCell.swift
SRSTreeView.swift
Constants.swift
and the assets disclosure_down and disclosure_right
You should also define some 'icons' for each line.
All images should be 15x15 at 1x


How to use it
--- 
First, it's pretty much assumed that you will be using the tree view in a ViewController.
Create a scroll view on your storyboard, and then select its type as a custom class ( SRSTreeView in this case).  Attach it to an object in your source code as an outlet.

Second, implement your ViewController just like you would UIListView with a delegate and datasource

```swift
class ViewController: UIViewController,SRSTreeViewDelegate,SRSTreeViewDataSource {
    @IBOutlet var treeView: SRSTreeView!
    
    var cellData = [SRSTreeViewCell]()

    ...
}

```

You will have to then implement the protocols for the datasource and delegate.
Note that you are only giving the tree view the number of parent items, that is the top most nodes.

## Datasource

```swift
    func numberOfParentTreeRows() -> Int{
        return 1 //your # of parent cells
    }
    
    func treeCellForRowAtIndex( index:Int ) -> SRSTreeViewCell{

    	//Create a parent cell for the index
	var cell:SRSTreeViewCell! = SRSTreeViewCell.init(cell: "Level 0 Item 0",  icon: "icon_0")

        cellData.append(cell)

	return cell
    }

```

## Delegate

```swift
    func didSelectRowAtIndex( index:Int ){
        //grab the cell from your saved data and go
        print("Index selected: ", index, " Title: ", cellData[index].cellTitle!)
    }
```



#License
[MIT](http://choosealicense.com/licenses/mit/) open source... 

#Donate
If you found it useful and it saved you time and effort, please donate...  Thank you!
[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/SStahurski)
