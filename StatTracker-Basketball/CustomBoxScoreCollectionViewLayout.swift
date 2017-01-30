//
//  CustomBoxScoreCollectionViewLayout.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 30/1/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomBoxScoreCollectionViewLayout: UICollectionViewLayout {
    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    let CELL_HEIGHT = 30.0
    let CELL_WIDTH = 100.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    
    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        
        // Only update header cells.
        if !dataSourceDidUpdate {
            
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
            let yOffset = collectionView!.contentOffset.y
            
            if (collectionView?.numberOfSections)! > 0 {
                for section in 0...collectionView!.numberOfSections-1 {
                    
                    // Confirm the section has items.
                    if (collectionView?.numberOfItems(inSection: section))! > 0 {
                        
                        // Update all items in the first row.
                        if section == 0 {
                            for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                                
                                // Build indexPath to get attributes from dictionary.
                                let indexPath = NSIndexPath(item: item, section: section)
                                
                                // Update y-position to follow user.
                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    
                                    // Also update x-position for corner cell.
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }
                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                            }
                            
                            // For all other sections, we only need to update
                            // the x-position for the first item.
                        } else {
                            
                            // Build indexPath to get attributes from dictionary.
                            let indexPath = NSIndexPath(item: 0, section: section)
                            
                            // Update y-position to follow user.
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }
                        }
                    }
                }
            }
            
            // Do not run attribute generation code
            // unless data source has been updated.
            return
        }
        
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        
        // Cycle through each section of the data source.
        if (collectionView?.numberOfSections)! > 0 {
            for section in 0...collectionView!.numberOfSections-1 {
                
                // Cycle through each item in the section.
                if (collectionView?.numberOfItems(inSection: section))! > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                        
                        // Build the UI CollectionViewLayout attributes for cell
                        let cellIndex = NSIndexPath(item: item, section: section)
                        var calculatedCellWidth: Double
                        var xPos: Double
                        
                        // Double the space between item 0 and item 1 cells
                        if item == 0 {
                            calculatedCellWidth = CELL_WIDTH * 2
                            xPos = Double(item) * calculatedCellWidth
                        } else if item == 1 {
                            calculatedCellWidth = CELL_WIDTH * 2
                            xPos = Double(item) * calculatedCellWidth
                        } else {
                            calculatedCellWidth = CELL_WIDTH
                            xPos = Double(item) * calculatedCellWidth + CELL_WIDTH
                        }
                        let yPos = Double(section) * CELL_HEIGHT
                        
                        var cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                        
                        // Double the border length of item 0 cells
                        if item == 0 {
                            cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH*2, height: CELL_HEIGHT)
                        } else {
                            cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        }
                        
                        // Determine zIndex based on cell type
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }
        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath as NSIndexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
