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
            startDate: "2025.09.12", // ✅ Past Date
            endDate: "2025.09.14",   // ✅ Past Date
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
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "방예담", image: "yedam", startTime: "14:10", endTime: "15:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2025.09.12"), // ✅ Adjusted Dates
                FestivalDay(dayOfWeek: "토", date: "2025.09.13"),
                FestivalDay(dayOfWeek: "일", date: "2025.09.14")
            ]
        ),
        
        Festival(
            imageName: "asian_pop_fes",
            name: "ASIAN POP FESTIVAL 2025",
            startDate: "2025.08.23", // ✅ Past Date
            endDate: "2025.08.24",   // ✅ Past Date
            location: "파라다이스시티",
            artistSchedule: [:],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.08.23"),
                FestivalDay(dayOfWeek: "일", date: "2025.08.24")
            ]
        ),
        
        Festival(
            imageName: "seoul_park_music",
            name: "SEOUL PARK MUSIC FESTIVAL 2025",
            startDate: "2025.08.30", // ✅ Past Date
            endDate: "2025.08.31",   // ✅ Past Date
            location: "올림픽공원",
            artistSchedule: [:],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.08.30"),
                FestivalDay(dayOfWeek: "일", date: "2025.08.31")
            ]
        ),
        
        Festival(
            imageName: "sound_berry",
            name: "SOUNDBERRY FESTA’ 25",
            startDate: "2025.09.06", // ✅ Past Date
            endDate: "2025.09.07",   // ✅ Past Date
            location: "일산 킨텍스 제 2전시장 9홀",
            artistSchedule: [:],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.09.06"),
                FestivalDay(dayOfWeek: "일", date: "2025.09.07")
            ]
        ),
        
        Festival(
            imageName: "icn_pentaport",
            name: "KB국민카드 스타샵 with 2025 인천펜타포트 락 페스티벌",
            startDate: "2025.09.19", // ✅ Past Date
            endDate: "2025.09.21",   // ✅ Past Date
            location: "송도달빛축제공원",
            artistSchedule: [:],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2025.09.19"),
                FestivalDay(dayOfWeek: "토", date: "2025.09.20"),
                FestivalDay(dayOfWeek: "일", date: "2025.09.21")
            ]
        ),
        
        Festival(
            imageName: "sound_berry",
            name: "WINTER SOUNDBERRY 25",
            startDate: "2025.08.16", // ✅ Past Date
            endDate: "2025.08.17",   // ✅ Past Date
            location: "코엑스",
            artistSchedule: [:],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.08.16"),
                FestivalDay(dayOfWeek: "일", date: "2025.08.17")
            ]
        )
    ]
}
