//
//  GameViewModel.swift
//  TicTacToeGame
//
//  Created by ck on 2023-08-28.
//

import SwiftUI


final class GameViewModel:ObservableObject{
    let columns:[GridItem]=[
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Published var moves:[Move?]=Array(repeating: nil, count: 9)
    @Published  var isGameBoardDisabled=false
    @Published var results:AlertItem?
    
    func processPlayerMove(for position:Int){
        if isSquareOccupied(for: moves, where: position){return}
        moves[position]=Move(player:  .human, boardIndex: position)
        
        //Check for win or draw
        if checkWin(for: moves, for: .human){
            results=AlertContext.humanWin
            return
        }
        if checkDraw(in: moves){
            results=AlertContext.draw
            
        
            return
        }
        isGameBoardDisabled=true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerMove = determineComputerPosition(in: moves)
            moves[computerMove]=Move(player:  .computer, boardIndex: computerMove)
            isGameBoardDisabled=false
            if checkWin(for: moves, for: .computer){
                results=AlertContext.comWin
                return
            }
            if checkDraw(in: moves){
                results=AlertContext.draw
                return
            }
            
        }
        
    }
    //check if square is occupied
    func isSquareOccupied(for moves:[Move?],where index:Int )->Bool{
        return moves.contains {
            $0?.boardIndex==index
        }
        
        
    }
    //check for computer position and make it play
    func determineComputerPosition(in moves:[Move?])->Int{
        var comPosition=Int.random(in: 0..<9)
        //If AI can win take a block
        let winPatterns:Set<Set<Int>>=[[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let computerMoves=moves.compactMap{$0}.filter{$0.player == .computer}
        let computerPosition=Set(computerMoves.map{$0.boardIndex})
        for pattern in winPatterns{
            let winPositions=pattern.subtracting(computerPosition)
            if winPositions.count==1{
                
                let isAvailable=isSquareOccupied(for: moves, where: winPositions.first!)
                if !isAvailable{
                    return winPositions.first!
                }
                
            }
            
        }
        
        
        //If human can win AI blocks
        let humanMoves=moves.compactMap{$0}.filter{$0.player == .human}
        let humanPosition=Set(humanMoves.map{$0.boardIndex})
        for pattern in winPatterns{
            let winPositions=pattern.subtracting(humanPosition)
            if winPositions.count==1{
                
                let isAvailable=isSquareOccupied(for: moves, where: winPositions.first!)
                if !isAvailable{
                    return winPositions.first!
                }
                
            }
            
        }
        
        
        //If AI can't win take middle square
        let centerSquare=4
        if !isSquareOccupied(for: moves, where: centerSquare){
            return centerSquare
        }
        
        //If AI can't win take random square
        while isSquareOccupied(for: moves, where: comPosition){
            comPosition=Int.random(in: 0..<9)
        }
        return comPosition
    }
    //check whether player wins
    func checkWin(for moves:[Move?],for player:Player)->Bool{
        let winPatterns:Set<Set<Int>>=[[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let playerMoves=moves.compactMap{$0}.filter{$0.player == player}
        let playerPosition=Set(playerMoves.map{$0.boardIndex})
        for pattern in winPatterns where pattern.isSubset(of: playerPosition){
            
            return true
            
        }
        
        return false
    }
    
    func checkDraw(in moves:[Move?])->Bool{
        return moves.compactMap{$0}.count==9
    }
    func resetGame(){
        moves=Array(repeating: nil, count: 9)
    }
    
    
}
