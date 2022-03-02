//
//  ViewController.swift
//  SRSTreeView
//
//  Created by Scott Stahurski 
//  Copyright © 2018 Scott Stahurski. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SRSTreeViewDelegate,SRSTreeViewDataSource {

    @IBOutlet var treeView: SRSTreeView!
    
    var cellData = [SRSTreeViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        treeView.treeViewDelegate = self
        treeView.datasource = self
    }
    
    
    //SRSTreeview Datasource ( just like UIListView )  just tell the view controller how many BEGINNING parent rows there are
    func numberOfParentTreeRows() -> Int{
        return 4
    }
    
    func treeCellForRowAtIndex( index:Int ) -> SRSTreeViewCell{
        
        var cell:SRSTreeViewCell!
        
        switch(index)
        {
        case 0:
            cell = SRSTreeViewCell.init(cell: "Level 0 Item 0",  icon: "icon_0")
            cellData.append(cell)
            //notice how we have to create the child items here....
                let childCell1 = SRSTreeViewCell.init(cell: "Level 1 Item 0",  icon: "icon_1")
                let childCell2 = SRSTreeViewCell.init(cell: "Level 1 Item 1",  icon: "icon_1")
            
                cellData.append(childCell1)
                cellData.append(childCell2)
            
            cell.addChild(child: childCell1)
                let childCell3 = SRSTreeViewCell.init(cell: "Level 2 Item 0",  icon: "icon_2")
                let childCell4 = SRSTreeViewCell.init(cell: "Level 2 Item 1",  icon: "icon_2")
                childCell1.addChild(child: childCell3)
                childCell1.addChild(child: childCell4)
            
                cellData.append(childCell3)
                cellData.append(childCell4)
            
            cell.addChild(child: childCell2)
            
            break
        case 1:
            cell = SRSTreeViewCell.init(cell: "Level 0 Item 1",  icon: "icon_0")
            cellData.append(cell)
            break
        case 2:
            cell = SRSTreeViewCell.init(cell: "Level 0 Item 2",  icon: "icon_0")
            cellData.append(cell)
            break
        case 3:
            cell = SRSTreeViewCell.init(cell: "Level 0 Item 3",  icon: "icon_0")
            cellData.append(cell)
            break
        default:
            cell = SRSTreeViewCell.init(cell: "Whoa...I shouldnt be here",  icon: "icon_0")
            break
        }
        
        return cell
    }

    //SRSTreeViewDelegate
    func didSelectRowAtIndex( index:Int ){
        print("Index selected: ", index, " Title: ", cellData[index].cellTitle!)
    }


}

