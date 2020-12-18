//
//  CircleProgress.swift
//  BookKeeping
//
//  Created by 沉寂 on 2020/12/17.
//

import SwiftUI

struct CircleProgress: View {
    @Binding var progress: Double
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                Circle()
                    .stroke(Color(.secondarySystemBackground), lineWidth: 5)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(Color(.systemYellow), style: .init(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.init(degrees: -90))
                
                VStack{
                    Text("Surplus")
                        .font(.system(size: geo.size.height / 8))
                    Text("\(Int(progress * 100))%").bold()
                        .font(.system(size: geo.size.height / 4))
                }
            }
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress(progress: .constant(0.3))
            .frame(width: 80, height: 80, alignment: .center)
    }
}


