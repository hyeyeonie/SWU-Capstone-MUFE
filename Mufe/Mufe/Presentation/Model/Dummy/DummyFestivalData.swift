//
//  DummyFestivalData.swift
//  Mufe
//
//  Created by 신혜연 on 6/12/26.
//

import UIKit

struct DummyFestivalData {
    static let festivals: [Festival] = [
        
        // ✅ 1. 알림 테스트용 페스티벌 (오늘: 11월 19일)
        Festival(
            imageName: "mufe_test_icon",
            name: "🔥 MUFE 알림 테스트",
            startDate: "2025.11.19",
            endDate: "2025.11.19",
            location: "오늘 (11/19)",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "TEST STAGE", location: "지금 테스트용", artists: [
                        // ⭐️ 공연 시작 01:10 -> [00:40]에 30분 전 알림이 울립니다!
                        ArtistSchedule(name: "🚨 30분 전 알림 테스트 🚨", image: "mufe", startTime: "01:20", endTime: "01:40"),
                        ArtistSchedule(name: "다음 공연", image: "mufe", startTime: "02:00", endTime: "03:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "수", date: "2025.11.19")
            ]
        ),
        
        // ... (나머지 페스티벌 데이터는 그대로 유지) ...
        // ✅ 2. (수정) 뷰티풀 민트 라이프 (3일로 확장 및 날짜/요일 수정)
        Festival(
            imageName: "beautiful_mint_life",
            name: "2025 뷰티풀민트라이프",
            startDate: "2025.11.15",
            endDate: "2025.11.17", // 3일로 수정
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [ // 11.15 (토)
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Hi-Fi Un!corn", image: "hifi", startTime: "11:00", endTime: "13:30"),
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
                "2일차": [ // 11.16 (일)
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "방예담", image: "yedam", startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "루시", image: "lucy", startTime: "15:30", endTime: "16:20")
                    ])
                ],
                "3일차": [ // 11.17 (월)
                     ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                         ArtistSchedule(name: "데이먼스 이어", image: "damonsyear", startTime: "13:00", endTime: "13:40"),
                         ArtistSchedule(name: "김필", image: "kimfeel", startTime: "14:10", endTime: "15:00"),
                         ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "15:30", endTime: "16:20")
                     ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.11.15"), // 요일 수정
                FestivalDay(dayOfWeek: "일", date: "2025.11.16"), // 추가
                FestivalDay(dayOfWeek: "월", date: "2025.11.17")  // 추가
            ]
        ),
        
        // ✅ 3. (정렬 수정) 그랜드 민트 페스티벌 2025
        Festival(
            imageName: "gmf_2025",
            name: "Grand Mint Festival 2025",
            startDate: "2025.10.25",
            endDate: "2025.10.26",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "Mint Breeze Stage", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "유다빈밴드", image: "yudabinband", startTime: "12:00", endTime: "12:40"),
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "13:20", endTime: "14:10"),
                        ArtistSchedule(name: "권진아", image: "kwonjinah", startTime: "14:40", endTime: "15:30"),
                        ArtistSchedule(name: "소란", image: "soran", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "17:20", endTime: "18:10"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "이승환", image: "leeseunghwan", startTime: "20:10", endTime: "21:10")
                    ]),
                    ArtistInfo(stage: "Loving Forest Garden", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "신인류", image: "shinryu", startTime: "16:50", endTime: "17:30"),
                        ArtistSchedule(name: "우용", image: "wooyong", startTime: "18:10", endTime: "18:50"),
                        ArtistSchedule(name: "김뜻돌", image: "kimddodol", startTime: "19:30", endTime: "20:10")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "Mint Breeze Stage", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "글렌체크", image: "glencheck", startTime: "14:40", endTime: "15:30"),
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "Colde", image: "colde", startTime: "17:20", endTime: "18:10"),
                        ArtistSchedule(name: "자우림", image: "jaurim", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "LUCY", image: "lucy", startTime: "20:10", endTime: "21:10")
                    ]),
                    ArtistInfo(stage: "Loving Forest Garden", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "최유리", image: "choiyuri", startTime: "18:10", endTime: "18:50"),
                        ArtistSchedule(name: "나상현씨밴드", image: "nasanghyuncband", startTime: "19:30", endTime: "20:10")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.10.25"),
                FestivalDay(dayOfWeek: "일", date: "2025.10.26")
            ]
        ),
        
        // ✅ 4. (정렬 수정) 2025 부산 락 페스티벌
        Festival(
            imageName: "busan_rock_fes",
            name: "2025 부산 락 페스티벌",
            startDate: "2025.11.01",
            endDate: "2025.11.02",
            location: "삼락생태공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "Samrock Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "새소년", image: "sesoneon", startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "The fin.", image: "thefin", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "국카스텐", image: "guckkasten", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "Phoenix", image: "phoenix", startTime: "21:00", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "Green Stage", location: "서브 스테이지", artists: [
                        ArtistSchedule(name: "이상은", image: "leesangeun", startTime: "19:00", endTime: "19:50"),
                        ArtistSchedule(name: "SURL", image: "surl", startTime: "20:20", endTime: "21:00")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "Samrock Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "HYBS", image: "hybs", startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "이승열", image: "leeseungyul", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "NEVER YOUNG BEACH", image: "neveryoungbeach", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "Turnstile", image: "turnstile", startTime: "21:00", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "Green Stage", location: "서브 스테이지", artists: [
                        ArtistSchedule(name: "갤럭시 익스프레스", image: "galaxyexpress", startTime: "19:00", endTime: "19:50"),
                        ArtistSchedule(name: "다섯", image: "dasutt", startTime: "20:20", endTime: "21:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.11.01"),
                FestivalDay(dayOfWeek: "일", date: "2025.11.02")
            ]
        ),
        
        // ✅ 5. (정렬 수정) RIDE THE BEAT 2025
        Festival(
            imageName: "ride_the_beat",
            name: "RIDE THE BEAT 2025",
            startDate: "2025.12.13",
            endDate: "2025.12.14",
            location: "KINTEX",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "Main Stage", location: "KINTEX 1홀", artists: [
                        ArtistSchedule(name: "Kid Milli", image: "kidmilli", startTime: "16:00", endTime: "16:40"),
                        ArtistSchedule(name: "ASH ISLAND", image: "ashisland", startTime: "17:00", endTime: "17:40"),
                        ArtistSchedule(name: "이센스", image: "esens", startTime: "18:00", endTime: "18:40"),
                        ArtistSchedule(name: "AP ALCHEMY", image: "apalchemy", startTime: "19:00", endTime: "19:40"),
                        ArtistSchedule(name: "VMV (VMC)", image: "vmv", startTime: "20:00", endTime: "20:40"),
                        ArtistSchedule(name: "E SENS", image: "esens", startTime: "21:00", endTime: "21:50")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "Main Stage", location: "KINTEX 1홀", artists: [
                        ArtistSchedule(name: "BIG Naughty", image: "bignaughty", startTime: "16:00", endTime: "16:40"),
                        ArtistSchedule(name: "Leellamarz", image: "leellamarz", startTime: "17:00", endTime: "17:40"),
                        ArtistSchedule(name: "GIRIBOY", image: "giriboy", startTime: "18:00", endTime: "18:40"),
                        ArtistSchedule(name: "CHANGMO", image: "changmo", startTime: "19:00", endTime: "19:40"),
                        ArtistSchedule(name: "AOMG", image: "aomg", startTime: "20:00", endTime: "20:40"),
                        ArtistSchedule(name: "Dynamic Duo", image: "dynamicduo", startTime: "21:00", endTime: "21:50")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.12.13"),
                FestivalDay(dayOfWeek: "일", date: "2025.12.14")
            ]
        ),

        // ✅ 6. (정렬 수정) COUNTDOWN FANTASY 2025-26
        Festival(
            imageName: "countdown_fantasy",
            name: "COUNTDOWN FANTASY 2025-26",
            startDate: "2025.12.30",
            endDate: "2026.01.01",
            location: "YES24 Live Hall",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "Main Stage", location: "YES24 Live Hall", artists: [
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "19:20", endTime: "20:10"),
                        ArtistSchedule(name: "데이브레이크", image: "daybreak", startTime: "20:40", endTime: "21:30"),
                        ArtistSchedule(name: "10CM", image: "10cm", startTime: "22:00", endTime: "23:00")
                    ])
                ],
                "2일차": [ // 12월 31일
                    ArtistInfo(stage: "Main Stage", location: "YES24 Live Hall", artists: [
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "19:20", endTime: "20:10"),
                        ArtistSchedule(name: "소란", image: "soran", startTime: "20:40", endTime: "21:30"),
                        ArtistSchedule(name: "이승윤", image: "leeseungyoon", startTime: "22:00", endTime: "23:00"),
                        ArtistSchedule(name: "LUCY", image: "lucy", startTime: "23:30", endTime: "00:30") // 새해 카운트다운
                    ])
                ],
                "3일차": [ // 1월 1일
                    ArtistInfo(stage: "Main Stage", location: "YES24 Live Hall", artists: [
                        ArtistSchedule(name: "SURL", image: "surl", startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "최유리", image: "choiyuri", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "19:40", endTime: "20:30"),
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "21:00", endTime: "22:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "화", date: "2025.12.30"),
                FestivalDay(dayOfWeek: "수", date: "2025.12.31"),
                FestivalDay(dayOfWeek: "목", date: "2026.01.01")
            ]
        ),
        
        // ✅ 7. (정렬 수정) Have A Nice Day #10
        Festival(
            imageName: "have_a_nice_day",
            name: "Have A Nice Day #10",
            startDate: "2026.04.18",
            endDate: "2026.04.19",
            location: "난지한강공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "HAND Stage", location: "Main Stage", artists: [
                        ArtistSchedule(name: "권진아", image: "kwonjinah", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "LUCY", image: "lucy", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "19:10", endTime: "20:00"),
                        ArtistSchedule(name: "폴킴", image: "paulkim", startTime: "20:30", endTime: "21:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "HAND Stage", location: "Main Stage", artists: [
                        ArtistSchedule(name: "최유리", image: "choiyuri", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "이무진", image: "leemujin", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "멜로망스", image: "melomance", startTime: "19:10", endTime: "20:00"),
                        ArtistSchedule(name: "10CM", image: "10cm", startTime: "20:30", endTime: "21:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2026.04.18"),
                FestivalDay(dayOfWeek: "일", date: "2026.04.19")
            ]
        ),

        // ✅ 8. (정렬 수정) HIPHOPPLAYA FESTIVAL 2026 (날짜 키 "1D" -> "1일차"로 수정)
        Festival(
            imageName: "hipplaya_2026",
            name: "HIPHOPPLAYA FESTIVAL 2026",
            startDate: "2026.05.02",
            endDate: "2026.05.03",
            location: "난지한강공원",
            artistSchedule: [
                "1일차": [ // "1D" -> "1일차"
                    ArtistInfo(stage: "Main Stage", location: "난지", artists: [
                        ArtistSchedule(name: "pH-1", image: "ph1", startTime: "18:00", endTime: "18:40"),
                        ArtistSchedule(name: "CHANGMO", image: "changmo", startTime: "19:00", endTime: "19:40"),
                        ArtistSchedule(name: "E SENS", image: "esens", startTime: "20:00", endTime: "20:40"),
                        ArtistSchedule(name: "ZICO", image: "zico", startTime: "21:00", endTime: "21:50")
                    ])
                ],
                "2일차": [ // "2D" -> "2일차"
                    ArtistInfo(stage: "Main Stage", location: "난지", artists: [
                        ArtistSchedule(name: "Woo Won Jae", image: "woowonjae", startTime: "18:00", endTime: "18:40"),
                        ArtistSchedule(name: "Loco", image: "loco", startTime: "19:00", endTime: "19:40"),
                        ArtistSchedule(name: "Crush", image: "crush", startTime: "20:00", endTime: "20:40"),
                        ArtistSchedule(name: "박재범", image: "jaypark", startTime: "21:00", endTime: "21:50")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2026.05.02"),
                FestivalDay(dayOfWeek: "일", date: "2026.05.03")
            ]
        ),
        
        // ✅ 9. (정렬 수정) Seoul Jazz Festival 2026
        Festival(
            imageName: "seoul_jazz_fes",
            name: "Seoul Jazz Festival 2026",
            startDate: "2026.05.29",
            endDate: "2026.05.31",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "May Forest", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "FKJ", image: "fkj", startTime: "16:40", endTime: "17:40"),
                        ArtistSchedule(name: "AKMU", image: "akmu", startTime: "18:20", endTime: "19:20"),
                        ArtistSchedule(name: "Lauv", image: "lauv", startTime: "20:00", endTime: "21:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "May Forest", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Jeremy Zucker", image: "jeremyzucker", startTime: "16:40", endTime: "17:40"),
                        ArtistSchedule(name: "Jungle", image: "jungle", startTime: "18:20", endTime: "19:20"),
                        ArtistSchedule(name: "Melody Gardot", image: "melodygardot", startTime: "20:00", endTime: "21:30")
                    ])
                ],
                "3일차": [
                    ArtistInfo(stage: "May Forest", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "백예린", image: "baekyerin", startTime: "16:40", endTime: "17:40"),
                        ArtistSchedule(name: "Crush", image: "crush", startTime: "18:20", endTime: "19:20"),
                        ArtistSchedule(name: "HONNE", image: "honne", startTime: "20:00", endTime: "21:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2026.05.29"),
                FestivalDay(dayOfWeek: "토", date: "2026.05.30"),
                FestivalDay(dayOfWeek: "일", date: "2026.05.31")
            ]
        ),

        // ✅ 10. (정렬 수정) World DJ Festival 2026
        Festival(
            imageName: "world_dj_fes",
            name: "World DJ Festival 2026",
            startDate: "2026.06.13",
            endDate: "2026.06.14",
            location: "과천 서울랜드",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "World Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "Lost Frequencies", image: "lostfrequencies", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "Alan Walker", image: "alanwalker", startTime: "20:00", endTime: "21:00"),
                        ArtistSchedule(name: "Gryffin", image: "gryffin", startTime: "21:00", endTime: "22:00"),
                        ArtistSchedule(name: "The Chainsmokers", image: "thechainsmokers", startTime: "22:00", endTime: "23:00")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "World Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "Vini Vici", image: "vinivici", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "Galantis", image: "galantis", startTime: "20:00", endTime: "21:00"),
                        ArtistSchedule(name: "Zedd", image: "zedd", startTime: "21:00", endTime: "22:00"),
                        ArtistSchedule(name: "Martin Garrix", image: "martingarrix", startTime: "22:00", endTime: "23:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2026.06.13"),
                FestivalDay(dayOfWeek: "일", date: "2026.06.14")
            ]
        ),
        
        // ✅ 11. (정렬 수정) WATERBOMB Seoul 2026
        Festival(
            imageName: "waterbomb_seoul",
            name: "WATERBOMB Seoul 2026",
            startDate: "2026.07.10",
            endDate: "2026.07.12",
            location: "미정 (서울)",
            artistSchedule: [
                "1일차": [ // 금
                    ArtistInfo(stage: "Green Team", location: "Green", artists: [
                        ArtistSchedule(name: "청하", image: "chungha", startTime: "18:30", endTime: "19:00"),
                        ArtistSchedule(name: "나연", image: "nayeon", startTime: "19:30", endTime: "20:00"),
                        ArtistSchedule(name: "ZICO", image: "zico", startTime: "20:30", endTime: "21:10")
                    ]),
                    ArtistInfo(stage: "Yellow Team", location: "Yellow", artists: [
                        ArtistSchedule(name: "우원재", image: "woowonjae", startTime: "18:00", endTime: "18:30"),
                        ArtistSchedule(name: "Loco", image: "loco", startTime: "19:00", endTime: "19:30"),
                        ArtistSchedule(name: "Crush", image: "crush", startTime: "20:00", endTime: "20:30")
                    ])
                ],
                "2일차": [ // 토
                    ArtistInfo(stage: "Green Team", location: "Green", artists: [
                        ArtistSchedule(name: "CHANGMO", image: "changmo", startTime: "19:30", endTime: "20:00"),
                        ArtistSchedule(name: "박재범", image: "jaypark", startTime: "20:30", endTime: "21:10")
                    ]),
                    ArtistInfo(stage: "Yellow Team", location: "Yellow", artists: [
                        ArtistSchedule(name: "Kiss of Life", image: "kissoflife", startTime: "19:00", endTime: "19:30"),
                        ArtistSchedule(name: "선미", image: "sunmi", startTime: "20:00", endTime: "20:30")
                    ])
                ],
                "3일차": [ // 일
                    ArtistInfo(stage: "Green Team", location: "Green", artists: [
                        ArtistSchedule(name: "Jessi", image: "jessi", startTime: "19:30", endTime: "20:00"),
                        ArtistSchedule(name: "Simon Dominic", image: "simondominic", startTime: "20:30", endTime: "21:10")
                    ]),
                    ArtistInfo(stage: "Yellow Team", location: "Yellow", artists: [
                        ArtistSchedule(name: "화사", image: "hwasa", startTime: "19:00", endTime: "19:30"),
                        ArtistSchedule(name: "BIG Naughty", image: "bignaughty", startTime: "20:00", endTime: "20:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2026.07.10"),
                FestivalDay(dayOfWeek: "토", date: "2026.07.11"),
                FestivalDay(dayOfWeek: "일", date: "2026.07.12")
            ]
        ),
        
        // ✅ 12. (정렬 수정) 2026 인천 펜타포트 락 페스티벌
        Festival(
            imageName: "icn_pentaport",
            name: "2026 인천 펜타포트 락 페스티벌",
            startDate: "2026.08.07",
            endDate: "2026.08.09",
            location: "송도달빛축제공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "KB Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "잔나비", image: "jannabi", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "검정치마", image: "theblackskirts", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "King Gizzard", image: "kinggizzard", startTime: "21:00", endTime: "22:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "KB Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "새소년", image: "sesoneon", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "Turnstile", image: "turnstile", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "Jack White", image: "jackwhite", startTime: "21:00", endTime: "22:30")
                    ])
                ],
                "3일차": [
                    ArtistInfo(stage: "KB Stage", location: "메인 스테이지", artists: [
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "이승윤", image: "leeseungyoon", startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "Vampire Weekend", image: "vampireweekend", startTime: "21:00", endTime: "22:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2026.08.07"),
                FestivalDay(dayOfWeek: "토", date: "2026.08.08"),
                FestivalDay(dayOfWeek: "일", date: "2026.08.09")
            ]
        )
    ]
}
