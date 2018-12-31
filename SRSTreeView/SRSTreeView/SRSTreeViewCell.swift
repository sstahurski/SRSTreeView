//
//  SRSTreeViewCell.swift
//  SRSTreeView
//
//  Created by Scott Stahurski 
//  Copyright © 2018 Scott Stahurski. All rights reserved.
//

import UIKit


protocol SRSTreeViewCellDelegate:class {

    func sectionExpanded( section:SRSTreeViewCell )
    func itemSelected( section:SRSTreeViewCell )
    
}


class SRSTreeViewCell: UIView {
    
    var delegate:SRSTreeViewCellDelegate!
    
    var isCellHidden:Bool = false
    var isExpanded:Bool   = true
    var cellLevel:Int     = 0
    var cellDepth:Int     = 0
    var viewWidth:Double  = 0.0
    
    var cellTitle:String!
    var cellImageName:String!
    
    var childItemsArray = [SRSTreeViewCell]()

    private override init(frame: CGRect) {
        super.init(frame:frame)
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("SRSTreeViewCell init")
    }
    
    init(cell title:String,  icon:String ){
        let frameWidth    = SIDE_MARGIN + ICON_WIDTH  + ICON_WIDTH + TITLE_WIDTH + SIDE_MARGIN;
        super.init( frame:CGRect(x: 0, y: 0, width: frameWidth, height: CELL_HEIGHT) )
        
        cellTitle = title
        cellImageName = icon
    }
    
    func setTreePosition( level:Int, depth:Int ){
        
        //calculate some constants
        let yPos:Double          = Double(level) * CELL_HEIGHT //where item is in the stack
        let iconXPos:Double      = Double(depth) * ICON_WIDTH  //indentation
        let frameWidth:Double    = SIDE_MARGIN + iconXPos + ICON_WIDTH  + ICON_WIDTH + TITLE_WIDTH + SIDE_MARGIN
        
        //create Frame Rect
        self.frame = CGRect(x: 0.0, y: yPos, width: frameWidth, height: CELL_HEIGHT)
        
        cellLevel = level;
        cellDepth = depth;
        viewWidth = frameWidth;
        
        self.createView()
        
    }
    
    func createView(){

        
        let iconXPos:Double    = ICON_WIDTH * Double(cellDepth) //indentation
        var startXPos:Double   = SIDE_MARGIN + iconXPos
        
        //create a button (disclosure indicator parent item with folder icon)
        if childItemsArray.count > 0
        {
            //Add the disclosure image button
            let button = UIButton(frame: CGRect(x: startXPos, y: 10.0, width: ICON_WIDTH, height: ICON_HEIGHT))
            button.titleLabel?.text = "";
            button.titleLabel?.numberOfLines = 2;
            button.setImage(UIImage(named: "disclosure_down"), for: .normal )
            
            //only allow parent items to expand
            button.addTarget(self, action: #selector( self.expandSelector(_:) ), for: .touchUpInside)
            self.addSubview(button)
        }
        
        //offset to next position
        startXPos += ICON_WIDTH;
            
        //Add the items icon
        let iconButton:UIButton = UIButton(frame: CGRect(x: startXPos, y: 10.0, width: ICON_WIDTH, height: ICON_HEIGHT))
        iconButton.setImage(UIImage(named:cellImageName), for:.normal )
        iconButton.addTarget(self, action: #selector( self.selectSelector(_:) ), for: .touchUpInside)
        self.addSubview(iconButton)
            
        //offset to next position
        startXPos += ICON_WIDTH + SIDE_MARGIN;
            
        //Add the title ( as a button )
        let titleButton:UIButton = UIButton(frame: CGRect(x: startXPos, y: 0, width: TITLE_WIDTH, height: CELL_HEIGHT))
        titleButton.addTarget(self, action: #selector( self.selectSelector(_:) ), for: .touchUpInside)
        titleButton.setTitle(self.cellTitle, for: .normal)
        titleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        titleButton.setTitleColor(UIColor.black, for: .normal)
        
        /*
        let title:UILabel = UILabel(frame: CGRect(x: 0, y: 10, width: titleButton.bounds.size.width, height: titleButton.bounds.size.height))
        title.text = self.cellTitle
        title.textColor = UIColor.black
        title.font = UIFont(name: "System", size: CGFloat(FONT_SIZE) )
        title.backgroundColor = UIColor.red
        titleButton.addSubview(title)
        */

        self.addSubview(titleButton)
      
    }
    
    func updateLevel( level:Int ) {
        let yPos = Double(level) * CELL_HEIGHT
        self.frame = CGRect(x: Double(self.frame.origin.x), y: yPos, width: Double(self.frame.size.width), height: Double(self.frame.size.height))

    }
    
    func updateWidth( width:Int){
        self.frame = CGRect(x: Double(self.frame.origin.x), y: Double(self.frame.origin.y), width: Double(width), height: Double(self.frame.size.height))
    }
    
    func getWidth() ->Double {
        return self.viewWidth
        
    }
    
    func addChild( child: SRSTreeViewCell){
        childItemsArray.append(child)
    }
    
    func getChildCount() -> Int
    {
        return childItemsArray.count
    }
    
    func getChild(index:Int) -> SRSTreeViewCell? {
        
        if index < self.childItemsArray.count{
            return childItemsArray[index]
        }
        
        return nil
    }
    
    func hasChildren() -> Bool {
        return childItemsArray.count > 0
    }

    func unselect() {
        
        let index:Int = (childItemsArray.count > 0) ? 2 : 1
        self.subviews[index].backgroundColor = UIColor.white

    }
    
    
    @objc func expandSelector(_ sender: UIButton!) {
        
        self.isExpanded = !isExpanded
        
        //set image
        var imageName:String = "disclosure_right.png"
        
        if isExpanded {
            imageName = "disclosure_down.png"
        }
        //create the disclosure image
        let buttonImage:UIImage = UIImage(named:imageName)!
        //set image for the button
        sender.setImage(buttonImage, for: .normal)
        
        //inform delegate
        if delegate != nil {
            self.delegate.sectionExpanded(section: self)
        }
        
    }
    
    @objc func selectSelector(_ sender: UIButton!) {
        
        if delegate != nil {
            self.delegate.itemSelected(section: self)
        }
        
        let index:Int = (childItemsArray.count > 0) ? 2 : 1
        self.subviews[index].backgroundColor = UIColor(displayP3Red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0)
        
    }

}
