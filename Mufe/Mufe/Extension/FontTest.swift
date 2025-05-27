//
//  FontTest.swift
//  Mufe
//
//  Created by 최하늘 on 5/27/25.
//

import SwiftUI

import SwiftUI

struct FontTest: View {
 
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            Text("어떤 페스티벌에\n참여하실 예정인가요?")
                .customFont(.f3xl_Bold)
                .foregroundColor(.gray70)
            
            Text("어떤 페스티벌에\n참여하실 예정인가요?")
                .customFont(.f2xl_SemiBold)
                .foregroundColor(.gray20)
            
            Text("어떤 페스티벌에\n참여하실 예정인가요?")
                .customFont(.flg_Medium)
                .foregroundColor(.primary70)
            
            Text("어떤 페스티벌에\n참여하실 예정인가요?")
                .customFont(.fxs_Regular)
                .foregroundColor(.primary30)
            
            Text("---")
            
            VStack (alignment: .leading, spacing: 20){
                Text("냥냥")
                Text("냥냥")
                Text("냥냥")
                Text("냥냥")
            }
            .customFont(.fsm_Bold)
            .foregroundColor(.gray50)
            
            Text("---")
            
            HStack(alignment: .top, spacing: 20){
                Text("멍멍")
                Text("멍멍")
                Text("멍멍")
                Text("멍멍")
            }
            .customFont(.fxl_SemiBold)
            .foregroundColor(.primary40)
        }
    }
}

#Preview {
    FontTest()
}

