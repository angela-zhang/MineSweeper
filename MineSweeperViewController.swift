//
//  MineSweeperViewController.swift
//  Final Project
//
//  Created by Angela Zhang on 11/17/16.
//  Copyright © 2016 com.angelazhang. All rights reserved.
//

import UIKit

class MineSweeperButton: UIButton {
    
    let row: Int
    let col: Int
    
    var isMine = false
    var neighboringMines = 0
    var isRevealed = false
    
    
    init(frame: CGRect, row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MineSweeperViewController: UIViewController {
    
    var squares: [[MineSweeperButton]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addUIElements()

        // Do any additional setup after loading the view.
    }

    func addUIElements() {
        
        for rownumber in 0...7 {
            var rowlist:[MineSweeperButton] = []
            for column in 0...7 {
                
                let mineButton = MineSweeperButton(frame: CGRect(x: 45*(rownumber + 1), y: 45 * (column + 1), width: 35, height: 35), row: rownumber, col: column)
                mineButton.backgroundColor = .gray
                mineButton.addTarget(self, action: #selector (squareWasPressed), for: .touchUpInside)
                
                // calculate if button is a mine
                mineButton.isMine = ((arc4random()%10) == 0)
                
                view.addSubview(mineButton)
                
                rowlist.append(mineButton)
                
            }
            
            squares.append(rowlist)
        }
        
        let restartButton = UIButton(frame: CGRect(x: 180, y: 425, width: 75, height: 25))
        restartButton.setTitle("Restart", for: UIControlState.normal)
        restartButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        restartButton.addTarget(self, action: #selector (restartGame) , for: .touchUpInside)
        view.addSubview(restartButton)
        
    }
    
    func numberOfNeighboringMines (mineButton: MineSweeperButton) {
        
        let neighbors = getNeighboringSquares(mineButton: mineButton)
        
        var numNeighboringMines = 0
        // for each neighbor with a mine, add 1 to this square's count
        for neighborSquare in neighbors {
            if neighborSquare.isMine {
                numNeighboringMines += 1
            }
        }
        mineButton.neighboringMines = numNeighboringMines
    }
    
    func getNeighboringSquares(mineButton: MineSweeperButton) -> [MineSweeperButton]{
        
        var neighbors:[MineSweeperButton] = []
        let adjacentOffsets = [(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)]
        for (rowOffset,colOffset) in adjacentOffsets {
            let optionalNeighbor: MineSweeperButton? = getTileAtLocation(row: mineButton.row+rowOffset, col: mineButton.col+colOffset)
            if let neighbor = optionalNeighbor {
                neighbors.append(neighbor)
            }
        }
        return neighbors
    }
    
    
    func getTileAtLocation(row : Int, col : Int) -> MineSweeperButton? {
        if row >= 0 && row < 8 && col >= 0 && col < 8 {
            return squares[row][col]
        } else {
            return nil
        }
    }
    
    func squareWasPressed(sender: MineSweeperButton) {
        
        sender.backgroundColor = .lightGray
        print(sender.isMine)
        if sender.isMine {
            // display that it is a mine
            sender.setTitle("X", for: UIControlState.normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            let failedLabel = UILabel(frame: CGRect(x: 100, y: 500, width: 300, height: 25))
            failedLabel.textAlignment = NSTextAlignment.center
            failedLabel.text = "YOU FAILED!!! :( click restart"
            failedLabel.textColor = .red
            view.addSubview(failedLabel)
        } else {
            // display number of neighboring mines
            numberOfNeighboringMines(mineButton: sender)
            sender.setTitle("\(sender.neighboringMines)", for: UIControlState.normal)
        }
    }
    
    func restartGame() {
        
        squares = []

        addUIElements()
        
        
    }
   

    
}
