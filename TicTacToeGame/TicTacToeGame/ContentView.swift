//
//  ContentView.swift
//  TicTacToeGame
//
//  Created by ck on 2023-08-28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel=GameViewModel()
   

    var body: some View {
        GeometryReader{ geometry in
            VStack{
               
                Spacer()
                Text("Tic Tac Toe 🕹️")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                LazyVGrid(columns: viewModel.columns,spacing: 15){
                
                ForEach(0..<9) { i in
                    ZStack{
                        GameSquareView(proxy: geometry)
                        
                        
                       GameImageView(systemImage: viewModel.moves[i]?.indicator ?? "" )
                        
                    }.onTapGesture {
                        viewModel.processPlayerMove(for: i)
                        
                    }
                    
                }
            }
            Spacer()
            }
        }.padding()
            .disabled(viewModel.isGameBoardDisabled)
            .background(Color.blue)
            .opacity(0.9)
            .alert(item: $viewModel.results) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton:.default(alertItem.buttonTitle, action: {viewModel.resetGame()}))
            }
                  
    }
   
}
enum Player{
    case human
    case computer
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Move{
    let player:Player
    let boardIndex:Int
    var indicator:String{
        if player == .human{
            return "xmark"
        }
        else{
            return "circle"
        }
    }
}

struct GameSquareView: View {
    var proxy:GeometryProxy

    var body: some View {
                Rectangle()
            .foregroundColor(Color.orange)
            .frame(width: proxy.size.width/3 - 10, height: proxy.size.width/3 - 10)
    }
}

struct GameImageView: View {
    var systemImage:String
    var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .foregroundColor(.white)
            .frame(width: 30,height: 30)
    }
}
