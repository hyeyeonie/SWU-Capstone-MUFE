//
//  DummyFestivalData.swift
//  Mufe
//
//  Created by 신혜연 on 6/12/25.
//

import UIKit

struct DummyFestivalData {
    static let festivals: [Festival] = [
        Festival(
            imageName: "beautiful_mint_life",
            name: "2025 뷰티풀민트라이프",
            startDate: "2025.06.13",
            endDate: "2025.06.15",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Hi-Fi Un!corn", image: "hifi", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "유주", image: "yuzu", startTime: "14:50", endTime: "15:40"),
                        ArtistSchedule(name: "오월오일", image: "maymay", startTime: "16:10", endTime: "17:00"),
                        ArtistSchedule(name: "SAM KIM", image: "samkim", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "선우정아", image: "sunsun", startTime: "18:50", endTime: "19:50"),
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "20:30", endTime: "21:30")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "AxMxP", image: "axmxp", startTime: "14:30", endTime: "15:10"),
                        ArtistSchedule(name: "Glen Check", image: "glencheck", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "The Solutions", image: "thesoultions", startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "QWER", image: "qwer", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "이승윤", image: "seungyoon", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "YB", image: "yb", startTime: "21:20", endTime: "22:20")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "orange flavored cigarettes", image: "ofc", startTime: "14:10", endTime: "14:50"),
                        ArtistSchedule(name: "김승주", image: "seungjoo", startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "DASUTT", image: "dasutt", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "황가람", image: "garam", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "옥상달빛", image: "okdal", startTime: "19:10", endTime: "20:10"),
                        ArtistSchedule(name: "하동균", image: "donggyun", startTime: "20:40", endTime: "21:40")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "방예담", image: "yedam", startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "소수빈", image: "soobin", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "소란", image: "soran", startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "하현상", image: "hyeonsang", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "정승환", image: "seunghwan", startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "O.O.O", image: "ooo", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "리도어", image: "redoor", startTime: "15:00", endTime: "15:50"),
                        ArtistSchedule(name: "너드커넥션", image: "nerdnerd", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "21:10", endTime: "22:10")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "0WAVE", image: "wave0", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "이강승", image: "kangseung", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "까치산", image: "kachisan", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "dori", image: "dori", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "권순관", image: "soonkwan", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "george", image: "george", startTime: "20:40", endTime: "21:40")
                    ])
                ],
                "3일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "우석", image: "wooseok", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "한로로", image: "hanroro", startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "유다빈밴드", image: "ydbb", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "로이킴", image: "roykim", startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "김성규", image: "sungkyu", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "윤하", image: "younha", startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "구원찬", image: "onechan", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "Colde", image: "colde", startTime: "15:00", endTime: "15:50"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "이석훈", image: "seokhoon", startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "10cm", image: "tencm", startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "다비치", image: "davichi", startTime: "21:10", endTime: "22:10")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "Dept", image: "dept", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "연정", image: "yeonjeong", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "안다영", image: "dayeong", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "오존", image: "ozone", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "브로콜리너마저", image: "broccoli", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "데이먼스 이어", image: "damonsyear", startTime: "20:40", endTime: "21:40")
                    ])
                ]
            ]
        ),
        
        Festival(
            imageName: "asian_pop_fes",
            name: "ASIAN POP FESTIVAL 2025",
            startDate: "2025.06.21",
            endDate: "2025.06.22",
            location: "파라다이스시티",
            artistSchedule: [:]
        ),
        
        Festival(
            imageName: "seoul_park_music",
            name: "ASIAN POP FESTIVAL 2025",
            startDate: "2025.06.28",
            endDate: "2025.06.29",
            location: "올림픽공원",
            artistSchedule: [:]
        ),
        
        Festival(
            imageName: "sound_berry",
            name: "SOUNDBERRY FESTA’ 25",
            startDate: "2025.07.19",
            endDate: "2025.07.20",
            location: "일산 킨텍스 제 2전시장 9홀",
            artistSchedule: [:]
        ),
        
        Festival(
            imageName: "icn_pentaport",
            name: "KB국민카드 스타샵 with 2025 인천펜타포트 락 페스티벌",
            startDate: "2025.08.01",
            endDate: "2025.08.03",
            location: "송도달빛축제공원",
            artistSchedule: [:]
        )
    ]
}
