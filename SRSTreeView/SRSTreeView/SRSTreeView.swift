//
//  SRSTreeView.swift
//  SRSTreeView
//
//  Created by Scott Stahurski 
//  Copyright © 2018 Scott Stahurski. All rights reserved.
//

import UIKit

//datasource delegate
protocol SRSTreeViewDataSource:class{

    func numberOfParentTreeRows() -> Int
    func treeCellForRowAtIndex( index:Int ) -> SRSTreeViewCell

}

//Tree View Delegate
protocol SRSTreeViewDelegate:class{
    func didSelectRowAtIndex( index:Int )
}


class SRSTreeView: UIScrollView, SRSTreeViewCellDelegate {
    
    var datasource:SRSTreeViewDataSource!
    var treeViewDelegate:SRSTreeViewDelegate!
    
    var rootItemArray:Array = [SRSTreeViewCell]()
    var fullViewArray:Array = [SRSTreeViewCell]()
    
    
    
    override func didMoveToWindow() {
        self.loadDataFromDatasource()
    }
    
    func reloadData(){
        self.loadDataFromDatasource()
    }
    
    func loadDataFromDatasource(){
        
        rootItemArray.removeAll()
        
        if self.datasource != nil {
            let parentCount:Int = self.datasource!.numberOfParentTreeRows()
            
            for index in 0..<parentCount
            {
                let cell:SRSTreeViewCell = self.datasource.treeCellForRowAtIndex(index:index)
                rootItemArray.append(cell)
            }
            
            self.drawTreeView()
        }
    }
    
    func drawTreeView(){
        
        //remove all subviews
        for view in self.fullViewArray{
            view.removeFromSuperview()
        }
        //clear all
        self.fullViewArray.removeAll()
        
        //draw tree starting with the first level objects
        var level:Int = 0
        for cell in self.rootItemArray{
            level = self.insertTreeViewItem(cell:cell, level:level, depth:0 )
            
        }
    
        //calculate the bounds
        var largestWidth:Double = 0
        //full array should be populated now update the widths
        //first get the largest
        for cell in fullViewArray{
            let width = cell.getWidth()
            
            if width > largestWidth{
                largestWidth = width
            }
        }
        
        for cell in fullViewArray {
            cell.updateWidth(width: Int(largestWidth))
        }

        self.contentSize = CGSize(width: largestWidth, height: (Double(self.subviews.count) * CELL_HEIGHT))
        
    }
    
    //recursive call
    func insertTreeViewItem(cell:SRSTreeViewCell, level:Int, depth:Int) -> Int{
        
        cell.setTreePosition(level: level, depth: depth)
        cell.delegate = self
        
        self.addSubview(cell)
        fullViewArray.append(cell)
        
        var itemLevel = level
        itemLevel += 1
        
        
        if cell.hasChildren() {
            
            let childCount:Int = cell.getChildCount()
            
            for index in 0..<childCount {
                let childCell:SRSTreeViewCell  = cell.getChild(index: index)!
                itemLevel = insertTreeViewItem(cell: childCell, level: itemLevel, depth: depth+1)
            }
            
        }
        
        return itemLevel

    }
    
    
    //DELEGATE Method
    func itemSelected( section:SRSTreeViewCell ){
        
        var index:Int = 0
        
        for cell in fullViewArray{
            cell.unselect()
            if treeViewDelegate != nil && cell == section{
                treeViewDelegate.didSelectRowAtIndex(index: index)
            }
            
            index += 1
        }
        
    }
    
    func sectionExpanded( section:SRSTreeViewCell ){
        
        //remove all views below this section
        var needsToBeRedrawn:Bool = false
        
        for cell in fullViewArray{
            if needsToBeRedrawn{
                cell.removeFromSuperview()
            }
            else{
                if cell == section {
                    needsToBeRedrawn = true
                }
            }
        }
        
        //now set only this sections children cells to hidden....recurse down
        self.hideAllChildren(cell: section)
        
        //now if only this sell is expanded, unhide those needed....recursive
        if section.isExpanded{
            self.expandChildren(cell: section)
        }
        
        //now redraw the tree from section down
        var startLevel = 0
        var needsAdded = false

        for cell in fullViewArray{
            if needsAdded{
                if !cell.isCellHidden{
                    cell.updateLevel(level: startLevel)
                    self.addSubview(cell)
                }
                else {
                    continue
                }
            }
            else if cell == section {
                needsAdded = true
                
            }
            
            if !cell.isCellHidden {
                startLevel += 1
            }
        }
        
    }
    
    func hideAllChildren(cell:SRSTreeViewCell){
        let childCount:Int = cell.getChildCount()
        
        for index in 0..<childCount {
            
            let childCell:SRSTreeViewCell! = cell.getChild(index: index)
            
            if childCell != nil{
                childCell.isCellHidden = true
                if childCell.hasChildren(){
                    self.hideAllChildren(cell: childCell)
                }
            }
        }
    }
    
    func expandChildren(cell:SRSTreeViewCell){
        
        let childCount:Int = cell.getChildCount()
        
        for index in 0..<childCount {
            
            let childCell:SRSTreeViewCell! = cell.getChild(index: index)
            
            if childCell != nil{
                childCell.isCellHidden = false
                if childCell.hasChildren() && childCell.isExpanded{
                    self.expandChildren(cell: childCell)
                }
            }
        }
    }
    

    
    
}
