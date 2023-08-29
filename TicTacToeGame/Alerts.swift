//
//  Alerts.swift
//  TicTacToeGame
//
//  Created by ck on 2023-08-28.
//

import SwiftUI

struct AlertItem:Identifiable{
    let id=UUID()
    let title:Text
    let message:Text
    let buttonTitle:Text
}

struct AlertContext{
   static let humanWin=AlertItem(title: Text("You win"), message: Text("You beat the computer congrats"), buttonTitle: Text("Hell yeah"))
    static  let comWin=AlertItem(title: Text("You lost"), message: Text("Your AI beated you"), buttonTitle: Text("Rematch"))
    static let draw=AlertItem(title: Text("It's a draw"), message: Text("The possible moves are done"), buttonTitle: Text("Try again"))

}
