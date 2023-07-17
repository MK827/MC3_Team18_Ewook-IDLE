//
//  BubbleGumMainView.swift
//  MC3Team18
//
//  Created by Minkyung Kim on 2023/07/11.
//

import SwiftUI



struct BubbleGumStatusView: View {
    @Binding var gameSelection: GameSelection
    @State var bubbleGumStatus: BubbleGumStatus = .tutorial
    
    var offsetValue: CGFloat = -740.0
        
    @State var currentExpressionIndex: Int = 0
    @State var backgroundOffset: CGFloat = -740
    @State var scale: CGFloat = 0.02
    @State var currentBubbleImageIndex = 0
    @State var score: String = "0"
    
    @ObservedObject var observer: AudioStreamObserver
    @State var text: String = ""
    var streamManager: AudioStreamManager
    
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    
    init(gameSelection: Binding<GameSelection>) {
        _gameSelection = gameSelection
        observer = AudioStreamObserver()
        streamManager = AudioStreamManager()
        streamManager.resultObservation(with: observer)
    }
    
    var body: some View {
        ZStack {
            BubbleGumMainView(bubbleGumStatus: $bubbleGumStatus, currentExpressionIndex: $currentExpressionIndex, backgroundOffset: $backgroundOffset, scale: $scale, currentBubbleImageIndex: $currentBubbleImageIndex, offsetX: $offsetX, offsetY: $offsetY)
            
            switch bubbleGumStatus {
            case .tutorial:
                BubbleGumTutorialView(bubbleGumStatus: $bubbleGumStatus)
                    .padding(.top, -offsetValue)
                    .padding(.bottom, -offsetValue)
            case .waiting:
                BubbleGumWaitingView(gamsSelection: $gameSelection, bubbleGumStatus: $bubbleGumStatus, streamManager: streamManager, observer: observer)
            case .game:
                BubbleGumGameView(bubbleGumStatus: $bubbleGumStatus, observer: observer, streamManager: streamManager, currentExpressionIndex: $currentExpressionIndex, backgroundOffset: $backgroundOffset, scale: $scale, score: $score, offsetX: $offsetX, offsetY: $offsetY)
            case .gameover:
                BubbleGumGameOverView(bubbleGumStatus: $bubbleGumStatus, gameSelection: $gameSelection, score: $score)
            }
        }
    }
}

struct BubbleGumMainView: View {
    @Binding var bubbleGumStatus: BubbleGumStatus
    
    @Binding var currentExpressionIndex: Int
    @Binding var backgroundOffset: CGFloat
    @Binding var scale: CGFloat
    @Binding var currentBubbleImageIndex: Int
    
    @Binding var offsetX: CGFloat
    @Binding var offsetY: CGFloat
    
    let expressionImagesYOffset = [-4.0, 0.0, -8.0]
    let expressionImages = ["ExpressionDefault", "ExpressionSleepy", "ExpressionTired",  "ExpressionGameover"]

    let animationGumSizeMaxDuration: Double = 30.0
    let bubbleImages = ["BubbleGumPink","BubbleGumOrange", "BubbleGumBlue"]
  
    let animationBackgroundMaxDuration: Double = 60.0
    let offsetValue: CGFloat = -740.0
   
    var body: some View {
        ZStack {
            // MARK: 배경 이미지
            Image("BackgroundBubbleGum")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: backgroundOffset)
                .animation(bubbleGumStatus == .game ? .linear(duration: animationBackgroundMaxDuration): .default, value: backgroundOffset)
            
            // MARK: 캐릭터 바디
            Image("MainCharacterBody")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 201)

            // MARK: 캐릭터 표정
            VStack {
                Spacer()
                Image(expressionImages[currentExpressionIndex])
                    .offset(y: expressionImagesYOffset[currentExpressionIndex])
            }
            .frame(width: 68, height: 52)
            .padding(.bottom, 78)
            
            // MARK: 버블껌 이미지
            Image(bubbleImages[currentBubbleImageIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale, anchor: .top)
                .offset(x: offsetX, y: offsetY)
                .offset(y: 168)
        }
    }
}

//struct BubbleGumMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        BubbleGumMainView(backgroundOffset: -740)
//    }
//}
