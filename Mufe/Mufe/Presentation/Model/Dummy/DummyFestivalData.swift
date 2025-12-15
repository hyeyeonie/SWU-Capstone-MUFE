//
//  DummyFestivalData.swift
//  Mufe
//
//  Created by 신혜연 on 6/12/26.
//

import UIKit

struct DummyFestivalData {
    static let festivals: [Festival] = [
        Festival(
            imageName: "theglow_2025",
            name: "더 글로우 2025 (THE GLOW 2025)",
            startDate: "2025.03.29",
            endDate: "2025.03.30",
            location: "킨텍스(KINTEX) 제2전시장",
            artistSchedule: [
                "1일차": [ // 03.29 (토)
                    ArtistInfo(stage: "STAGE 37", location: "HALL 7", artists: [
                        ArtistSchedule(name: "시라카미 우즈", image: "shirakami", startTime: "12:30", endTime: "13:05"),
                        ArtistSchedule(name: "BABO", image: "babo", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "15:00", endTime: "15:40"),
                        ArtistSchedule(name: "나상현씨밴드", image: "bandnah", startTime: "16:20", endTime: "17:00"),
                        ArtistSchedule(name: "ALI", image: "ali", startTime: "17:45", endTime: "18:30"),
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "19:20", endTime: "20:10"),
                        ArtistSchedule(name: "잔나비", image: "jannabi", startTime: "21:00", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "STAGE 126", location: "HALL 9", artists: [
                        ArtistSchedule(name: "송소희", image: "songsohee", startTime: "13:05", endTime: "13:40"),
                        ArtistSchedule(name: "DECA JOINS", image: "decajoins", startTime: "14:20", endTime: "15:00"),
                        ArtistSchedule(name: "윤마치", image: "yunmarch", startTime: "15:40", endTime: "16:20"),
                        ArtistSchedule(name: "COSMO'S MIDNIGHT", image: "cosmos", startTime: "17:00", endTime: "17:45"),
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "18:30", endTime: "19:20"),
                        ArtistSchedule(name: "이승윤", image: "seungyoon", startTime: "20:10", endTime: "21:00")
                    ])
                       ],
                "2일차": [ // 03.30 (일)
                    ArtistInfo(stage: "STAGE 37", location: "HALL 7", artists: [
                        ArtistSchedule(name: "리브아워티어스", image: "leaveourtears", startTime: "12:30", endTime: "13:05"),
                        ArtistSchedule(name: "BILLYRROM", image: "billy", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "지소쿠리클럽", image: "jisokuriclub", startTime: "15:00", endTime: "15:40"),
                        ArtistSchedule(name: "MILD ORANGE", image: "mildorange", startTime: "16:20", endTime: "17:00"),
                        ArtistSchedule(name: "데이먼스이어", image: "damonsyear", startTime: "17:45", endTime: "18:30"),
                        ArtistSchedule(name: "쏜애플", image: "thornapple", startTime: "19:20", endTime: "20:10"),
                        ArtistSchedule(name: "NELL", image: "nell", startTime: "21:00", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "STAGE 126", location: "HALL 9", artists: [
                        ArtistSchedule(name: "마라케시", image: "mara", startTime: "13:05", endTime: "13:40"),
                        ArtistSchedule(name: "YONLAPA", image: "yonlapa", startTime: "14:20", endTime: "15:00"),
                        ArtistSchedule(name: "리도어", image: "redoor", startTime: "15:40", endTime: "16:20"),
                        ArtistSchedule(name: "한로로", image: "hanroro", startTime: "17:00", endTime: "17:45"),
                        ArtistSchedule(name: "GLEN CHECK", image: "glencheck", startTime: "18:30", endTime: "19:20"),
                        ArtistSchedule(name: "장기하", image: "kiha", startTime: "20:10", endTime: "21:00")
                    ])
                       ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2025.03.29"),
                FestivalDay(dayOfWeek: "일", date: "2025.03.30")
            ]
        ),
        
        Festival(
            imageName: "beautiful_mint_life",
            name: "뷰티풀 민트 라이프 2025",
            startDate: "2025.06.13",
            endDate: "2025.06.15",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [ // 06.13 (금)
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
                    ArtistInfo(stage: "STAGE 3", location: "88호수수변무대", artists: [
                        ArtistSchedule(name: "orange flavored cigarettes", image: "ofc", startTime: "14:10", endTime: "14:50"),
                        ArtistSchedule(name: "김승주", image: "seungjoo", startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "다섯", image: "dasutt", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "황가람", image: "garam", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "옥상달빛", image: "okdal", startTime: "19:10", endTime: "20:10"),
                        ArtistSchedule(name: "하동균", image: "donggyun", startTime: "20:40", endTime: "21:40")
                    ])
                       ],
                "2일차": [ // 06.14 (토)
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "방예담", image: "yedam", startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "루시", image: "lucy", startTime: "15:30", endTime: "16:20"),
                        ArtistSchedule(name: "소수빈", image: "sosoobin", startTime: "15:40", endTime: "16:30"),
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
                    ArtistInfo(stage: "STAGE 3", location: "88호수수변무대", artists: [
                        ArtistSchedule(name: "0WAVE", image: "wave0", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "이강승", image: "kangseung", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "까치산", image: "kachisan", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "dori", image: "dori", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "권순관", image: "soonkwan", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "george", image: "george", startTime: "20:40", endTime: "21:40")
                    ])
                       ],
                "3일차": [ // 06./15 (일)
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "우석", image: "wooseok", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "한로로", image: "hanroro", startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "유다빈밴드", image: "ydbb", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "로이킴", image: "roykim", startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "김성규", image: "sungkyu", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "윤하", image: "younha", startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "구원찬", image: "onechan", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "Colde", image: "colde", startTime: "15:00", endTime: "15:50"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "이석훈", image: "seokhoon", startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "10CM", image: "tencm", startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "다비치", image: "davichi", startTime: "21:10", endTime: "22:10")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수수변무대", artists: [
                        ArtistSchedule(name: "Dept", image: "dept", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "연정", image: "yeonjeong", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "안다영", image: "dayeong", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "오존", image: "ozone", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "브로콜리너마저", image: "broccoli", startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "데이먼스이어", image: "damonsyear", startTime: "20:40", endTime: "21:40")
                    ])
                       ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2025.06.13"),
                FestivalDay(dayOfWeek: "토", date: "2025.06.14"),
                FestivalDay(dayOfWeek: "일", date: "2025.06.15")
            ]
        ),
        
        Festival(
            imageName: "somday_xmas",
            name: "Someday Christmas 2025",
            startDate: "2025.12.25",
            endDate: "2025.12.26",
            location: "부산 벡스코",
            artistSchedule: [
                "1일차": [
                    // MARK: - UNIQUE
                    ArtistInfo(stage: "UNIQUE", location: "UNIQUE", artists: [
                        ArtistSchedule(name: "신인류", image: "shininryu", startTime: "13:40", endTime: "14:30"),
                        ArtistSchedule(name: "다섯", image: "dasutt", startTime: "15:20", endTime: "16:10"),
                        ArtistSchedule(name: "I.M", image: "iam", startTime: "17:00", endTime: "17:40"),
                        ArtistSchedule(name: "오월오일", image: "owoloil", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "10CM", image: "tencm", startTime: "20:40", endTime: "21:40"),
                    ]),
                    
                    // MARK: - TOUCH
                    ArtistInfo(stage: "TOUCH", location: "TOUCH", artists: [
                        ArtistSchedule(name: "프랭클리", image: "frankly", startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "드래곤포니", image: "dragonpony", startTime: "14:30", endTime: "15:20"),
                        ArtistSchedule(name: "나상현씨밴드", image: "bandnah", startTime: "16:10", endTime: "17:00"),
                        ArtistSchedule(name: "유다빈밴드", image: "yudabinband", startTime: "17:40", endTime: "18:40"),
                        ArtistSchedule(name: "데이먼스이어", image: "damonsyear", startTime: "19:40", endTime: "20:40"),
                    ])
                ],
                
                "2일차": [
                    // MARK: - UNIQUE
                    ArtistInfo(stage: "UNIQUE", location: "UNIQUE", artists: [
                        ArtistSchedule(name: "AxMxP", image: "axmxp", startTime: "13:00", endTime: "13:30"),
                        ArtistSchedule(name: "구원찬", image: "koowonchan", startTime: "14:00", endTime: "14:40"),
                        ArtistSchedule(name: "극동아시아타이거즈", image: "kat", startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "송소희", image: "songsohee", startTime: "16:50", endTime: "17:40"),
                        ArtistSchedule(name: "한로로", image: "hanroro", startTime: "18:30", endTime: "19:30"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "20:30", endTime: "21:30")
                    ]),
                    
                    // MARK: - TOUCH
                    ArtistInfo(stage: "TOUCH", location:"TOUCH", artists: [
                        ArtistSchedule(name: "심아일랜드", image: "simileland", startTime: "13:30", endTime: "14:00"),
                        ArtistSchedule(name: "김승주", image: "kimseungjoo", startTime: "14:40", endTime: "15:20"),
                        ArtistSchedule(name: "까치산", image: "kachisan", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "윤마치", image: "yunmarch", startTime: "17:40", endTime: "18:30"),
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "19:30", endTime: "20:30"),
                    ])
                    
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "목", date: "2025.12.25"),
                FestivalDay(dayOfWeek: "금", date: "2025.12.26")
            ]
        ),
        
        Festival(
            imageName: "thecry",
            name: "2025 THE CRY ground - Last Holiday - 부산",
            startDate: "2025.12.28",
            endDate: "2025.12.28",
            location: "부산 BEXCO",
            artistSchedule: [
                "1일차": [
                    // MARK: - OASIS
                    ArtistInfo(stage: "OASIS", location: "부산 BEXCO", artists: [
                        ArtistSchedule(name: "JUTO", image: "juto", startTime: "12:30", endTime: "13:00"),
                        ArtistSchedule(name: "GEMINI", image: "gemini", startTime: "13:30", endTime: "14:00"),
                        ArtistSchedule(name: "NO:EL", image: "noel", startTime: "14:30", endTime: "15:00"),
                        ArtistSchedule(name: "양홍원", image: "yanghongwon", startTime: "15:00", endTime: "15:30"),
                        ArtistSchedule(name: "Kid Milli", image: "kidmilli", startTime: "15:30", endTime: "16:00"),
                        ArtistSchedule(name: "한요한", image: "hanyohan", startTime: "16:40", endTime: "17:10"),
                        ArtistSchedule(name: "YUMDDA", image: "yumdda", startTime: "17:40", endTime: "18:10"),
                        ArtistSchedule(name: "BIG Naughty", image: "bignaugthy", startTime: "18:40", endTime: "19:10"),
                        ArtistSchedule(name: "Dabin.kr", image: "dabinkr", startTime: "19:40", endTime: "20:10"),
                        ArtistSchedule(name: "Sik-K", image: "sikk", startTime: "20:40", endTime: "21:20")
                    ]),
                    
                    // MARK: - UTOPIA
                    ArtistInfo(stage: "UTOPIA", location: "부산 BEXCO", artists: [
                        ArtistSchedule(name: "율음", image: "yuleum", startTime: "13:00", endTime: "13:30"),
                        ArtistSchedule(name: "HOMIES", image: "homies", startTime: "14:00", endTime: "14:30"),
                        ArtistSchedule(name: "Balming Tiger", image: "balmingtiger", startTime: "16:00", endTime: "16:40"),
                        ArtistSchedule(name: "BewhY", image: "bewhy", startTime: "17:10", endTime: "17:40"),
                        ArtistSchedule(name: "B.I", image: "bi", startTime: "18:10", endTime: "18:40"),
                        ArtistSchedule(name: "pH-1", image: "ph1", startTime: "19:10", endTime: "19:40"),
                        ArtistSchedule(name: "E SENS", image: "esens", startTime: "20:10", endTime: "20:40")
                    ]),
                    
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "일", date: "2025.12.28")
            ]
        ),
        
        Festival(
            imageName: "countdown_fantasy",
            name: "COUNTDOWN FANTASY 2025-2026",
            startDate: "2025.12.15",
            endDate: "2025.12.16",
            location: "일산 KINTEX",
            artistSchedule: [
                "1일차": [
                    // MARK: - VIVID PLANET 26
                    ArtistInfo(stage: "VIVID PLANET 26", location: "일산 KINTEX", artists: [
                        ArtistSchedule(name: "손을모아", image: "sonmoa", startTime: "13:10", endTime: "13:40"),
                        ArtistSchedule(name: "심아일랜드", image: "simileland", startTime: "14:00", endTime: "14:40"),
                        ArtistSchedule(name: "Hi-Fi Un!corn", image: "hifi", startTime: "15:10", endTime: "15:50"),
                        ArtistSchedule(name: "can't be blue", image: "cantbeblue", startTime: "16:20", endTime: "17:00"),
                        ArtistSchedule(name: "고고학", image: "gogohak", startTime: "17:30", endTime: "18:10"),
                        ArtistSchedule(name: "ADOY", image: "adoy", startTime: "18:40", endTime: "19:20"),
                        ArtistSchedule(name: "쏜애플", image: "thornapple", startTime: "19:50", endTime: "20:40"),
                        ArtistSchedule(name: "CNBLUE", image: "cnblue", startTime: "21:10", endTime: "22:10")
                    ]),
                    
                    // MARK: - STATION STARDUST
                    ArtistInfo(stage: "STATION STARDUST", location: "일산 KINTEX", artists: [
                        ArtistSchedule(name: "유령서점", image: "uryeong", startTime: "13:40", endTime: "14:10"),
                        ArtistSchedule(name: "AxMxP", image: "axmxp", startTime: "14:30", endTime: "15:10"),
                        ArtistSchedule(name: "차승우와 사촌들", image: "chawithchild", startTime: "15:40", endTime: "16:20"),
                        ArtistSchedule(name: "THE SOLUTIONS", image: "thesolutions", startTime: "16:50", endTime: "17:30"),
                        ArtistSchedule(name: "오월오일", image: "maymay", startTime: "18:00", endTime: "18:40"),
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "19:10", endTime: "20:00"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "20:30", endTime: "21:30")
                    ]),
                ],
                
                "2일차": [
                    // MARK: - VIVID PLANET 26
                    ArtistInfo(stage: "VIVID PLANET 26", location: "일산 KINTEX", artists: [
                        ArtistSchedule(name: "컨파인트 화이트", image: "confinedwhite", startTime: "18:40", endTime: "19:10"),
                        ArtistSchedule(name: "whiteusedsocks", image: "whiteusedsocks", startTime: "19:30", endTime: "20:10"),
                        ArtistSchedule(name: "프랭클리", image: "frankly", startTime: "20:40", endTime: "21:20"),
                        ArtistSchedule(name: "까치산", image: "kachisan", startTime: "21:50", endTime: "22:30"),
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "23:00", endTime: "23:50"),
                        ArtistSchedule(name: "너드커넥션", image: "nerdnerd", startTime: "00:20", endTime: "01:10"),
                        ArtistSchedule(name: "유다빈밴드", image: "ydbb", startTime: "01:40", endTime: "02:30")
                    ]),
                    
                    // MARK: - STATION STARDUST
                    ArtistInfo(stage: "STATION STARDUST", location: "일산 KINTEX", artists: [
                        ArtistSchedule(name: "언오피셜", image: "unxl", startTime: "19:10", endTime: "19:40"),
                        ArtistSchedule(name: "KIK", image: "kik", startTime: "20:00", endTime: "20:40"),
                        ArtistSchedule(name: "소란", image: "soran", startTime: "21:10", endTime: "21:50"),
                        ArtistSchedule(name: "극동아시아타이거즈", image: "kat", startTime: "22:20", endTime: "23:00"),
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "23:30", endTime: "00:30"),
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "01:00", endTime: "01:50"),
                        ArtistSchedule(name: "LOW HIGH LOW", image: "lowhighlow", startTime: "02:10", endTime: "02:50"),
                        ArtistSchedule(name: "IDIOTAPE", image: "idiotape", startTime: "03:10", endTime: "04:00")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "월", date: "2025.12.15"),
                FestivalDay(dayOfWeek: "화", date: "2025.12.16")
            ]
        ),
        
        Festival(
            imageName: "seoul_park_music_fes",
            name: "2025 서울파크뮤직페스티벌",
            startDate: "2026.06.28",
            endDate: "2026.06.29",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "PARK STAGE", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "14:00", endTime: "14:30"),
                        ArtistSchedule(name: "윤마치", image: "yunmarch", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "정준일", image: "junil", startTime: "15:50", endTime: "16:30"),
                        ArtistSchedule(name: "최유리", image: "yuri", startTime: "16:50", endTime: "17:30"),
                        ArtistSchedule(name: "권진아", image: "jina", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "장범준", image: "beomjun", startTime: "19:00", endTime: "19:50"),
                        ArtistSchedule(name: "루시", image: "lucy", startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "KSPO DOME", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "BABO", image: "babo", startTime: "14:20", endTime: "15:00"),
                        ArtistSchedule(name: "태버", image: "tabber", startTime: "15:20", endTime: "15:50"),
                        ArtistSchedule(name: "지소쿠리클럽", image: "jisokuriclub", startTime: "16:10", endTime: "16:50"),
                        ArtistSchedule(name: "기리보이", image: "giriboy", startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "하성운", image: "sungwoon", startTime: "18:30", endTime: "19:20"),
                        ArtistSchedule(name: "CNBLUE", image: "cnblue", startTime: "19:50", endTime: "20:50"),
                        ArtistSchedule(name: "NELL", image: "nell", startTime: "21:30", endTime: "22:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "PARK STAGE", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "김수영", image: "suyoung", startTime: "14:00", endTime: "14:30"),
                        ArtistSchedule(name: "홍이삭", image: "isaac", startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "스텔라장", image: "stella", startTime: "15:50", endTime: "16:30"),
                        ArtistSchedule(name: "정세운", image: "sewoon", startTime: "16:50", endTime: "17:30"),
                        ArtistSchedule(name: "카더가든", image: "carthegarden", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "폴킴", image: "paulkim", startTime: "19:00", endTime: "19:50"),
                        ArtistSchedule(name: "자우림", image: "jaurim", startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "KSPO DOME", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "릴보이", image: "lilboi", startTime: "14:20", endTime: "15:10"),
                        ArtistSchedule(name: "이븐", image: "even", startTime: "15:30", endTime: "16:10"),
                        ArtistSchedule(name: "쏠", image: "sole", startTime: "16:30", endTime: "17:00"),
                        ArtistSchedule(name: "볼빨간 사춘기", image: "bol4", startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "BIG Naughty", image: "bignaugthy", startTime: "18:40", endTime: "19:30"),
                        ArtistSchedule(name: "다이나믹듀오", image: "dadu", startTime: "20:00", endTime: "21:00"),
                        ArtistSchedule(name: "제로베이스원", image: "zb1", startTime: "21:30", endTime: "22:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2026.06.28"),
                FestivalDay(dayOfWeek: "일", date: "2026.06.29")
            ]
        ),
        Festival(
            imageName: "busan_rock_festa",
            name: "부산 록 페스티벌 2025",
            startDate: "2026.09.26",
            endDate: "2026.09.27",
            location: "삼락생태공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "SAMROCK STAGE", artists: [
                        ArtistSchedule(name: "신인류", image: "shininryu", startTime: "12:00", endTime: "12:30"),
                        ArtistSchedule(name: "Flesh Juicer", image: "flesh", startTime: "13:00", endTime: "13:30"),
                        ArtistSchedule(name: "go!go!vanillas", image: "gogo", startTime: "14:00", endTime: "14:40"),
                        ArtistSchedule(name: "한로로", image: "hanroro", startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "쏜애플", image: "thornapple", startTime: "16:50", endTime: "17:40"),
                        ArtistSchedule(name: "자우림", image: "jaurim", startTime: "18:30", endTime: "19:30"),
                        ArtistSchedule(name: "SUEDE", image: "suede", startTime: "20:40", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "GREEN STAGE", artists: [
                        ArtistSchedule(name: "더 보울스", image: "thebowls", startTime: "11:30", endTime: "12:00"),
                        ArtistSchedule(name: "아디오스오디오", image: "adios", startTime: "12:30", endTime: "13:00"),
                        ArtistSchedule(name: "오칠", image: "ochil", startTime: "13:30", endTime: "14:00"),
                        ArtistSchedule(name: "강형호", image: "pitta", startTime: "14:40", endTime: "15:20"),
                        ArtistSchedule(name: "Xdinary Heroes", image: "xdz", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "CNBLUE", image: "cnblue", startTime: "17:40", endTime: "18:30"),
                        ArtistSchedule(name: "NELL", image: "nell", startTime: "19:40", endTime: "20:40")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "RIVER STAGE", artists: [
                        ArtistSchedule(name: "Tokai", image: "tokai", startTime: "11:30", endTime: "12:00"),
                        ArtistSchedule(name: "W24", image: "w24", startTime: "12:20", endTime: "12:50"),
                        ArtistSchedule(name: "정우", image: "jungwoo", startTime: "13:10", endTime: "13:50"),
                        ArtistSchedule(name: "원위", image: "onewe", startTime: "14:10", endTime: "14:50"),
                        ArtistSchedule(name: "QWER", image: "qwer", startTime: "15:10", endTime: "15:50"),
                        ArtistSchedule(name: "플라워", image: "flower", startTime: "16:10", endTime: "16:50"),
                        ArtistSchedule(name: "ASH ISLAND", image: "ash", startTime: "17:20", endTime: "18:00")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "SAMROCK STAGE", artists: [
                        ArtistSchedule(name: "양치기소년단", image: "sheep", startTime: "12:00", endTime: "12:30"),
                        ArtistSchedule(name: "리도어", image: "redoor", startTime: "13:00", endTime: "13:30"),
                        ArtistSchedule(name: "Sorry Youth", image: "sorry", startTime: "14:00", endTime: "14:40"),
                        ArtistSchedule(name: "Balming Tiger", image: "balmingtiger", startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "WANIMA", image: "wanima", startTime: "16:50", endTime: "17:40"),
                        ArtistSchedule(name: "윤수일밴드", image: "yunsuil", startTime: "18:30", endTime: "19:20"),
                        ArtistSchedule(name: "THE SMASHING PUMPKINS", image: "pumkin", startTime: "20:40", endTime: "22:00")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "GREEN STAGE", artists: [
                        ArtistSchedule(name: "극동아시아타이거즈", image: "kat", startTime: "11:30", endTime: "12:00"),
                        ArtistSchedule(name: "단편선 순간들", image: "danpeon", startTime: "12:30", endTime: "13:00"),
                        ArtistSchedule(name: "키라라", image: "kirara", startTime: "13:30", endTime: "14:00"),
                        ArtistSchedule(name: "LUCKLIFE", image: "lucklife", startTime: "14:40", endTime: "15:20"),
                        ArtistSchedule(name: "너드커넥션", image: "nerdnerd", startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "GLEN CHECK", image: "glencheck", startTime: "17:40", endTime: "18:30"),
                        ArtistSchedule(name: "MIKA", image: "mika", startTime: "19:30", endTime: "20:40")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "RIVER STAGE", artists: [
                        ArtistSchedule(name: "컨파인드 화이트", image: "confinedwhite", startTime: "11:30", endTime: "12:00"),
                        ArtistSchedule(name: "Hi-Fi Un!corn", image: "hifi", startTime: "12:20", endTime: "12:50"),
                        ArtistSchedule(name: "팔칠댄스", image: "palchil", startTime: "13:10", endTime: "13:50"),
                        ArtistSchedule(name: "윤마치", image: "yunmarch", startTime: "14:10", endTime: "14:50"),
                        ArtistSchedule(name: "muque", image: "muque", startTime: "15:10", endTime: "15:50"),
                        ArtistSchedule(name: "위아더나잇", image: "weare", startTime: "16:10", endTime: "16:50"),
                        ArtistSchedule(name: "짙은", image: "zitten", startTime: "17:20", endTime: "18:00"),
                        ArtistSchedule(name: "오존x카더가든", image: "ozone", startTime: "18:40", endTime: "19:30")
                    ])
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "금", date: "2026.09.26"),
                FestivalDay(dayOfWeek: "토", date: "2026.09.27")
            ]
        ),
        Festival(
            imageName: "grand_mint_festival",
            name: "그랜드 민트 페스티벌 2025",
            startDate: "2026.10.18",
            endDate: "2026.10.19",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo( stage: "Mint Breeze Stage", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "까치산", image: "kachisan", startTime: "12:50", endTime: "13:30"),
                        ArtistSchedule(name: "george", image: "george", startTime: "14:00", endTime: "14:50"),
                        ArtistSchedule(name: "폴킴", image: "paulkim", startTime: "15:30", endTime: "16:20"),
                        ArtistSchedule(name: "정승환", image: "seunghwan", startTime: "17:00", endTime: "18:00"),
                        ArtistSchedule(name: "적재", image: "jukjae", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "AKMU", image: "akmu", startTime: "20:20", endTime: "21:20")
                    ]
                              ),
                    ArtistInfo(stage: "Club Midnight Sunset", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "can't be blue", image: "cantbeblue", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "김뜻돌", image: "kimddeutdol", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "유다빈밴드", image: "ydbb", startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "Daybreak", image: "daybreak", startTime: "17:50", endTime: "18:50"),
                        ArtistSchedule(name: "터치드", image: "touched", startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "루시", image: "lucy", startTime: "21:10", endTime: "22:10")
                    ]
                              ),
                    ArtistInfo( stage: "Station Stardust", location: "88호수수변무대", artists: [
                        ArtistSchedule(name: "KIK", image: "kik", startTime: "12:30", endTime: "13:10"),
                        ArtistSchedule(name: "리도어", image: "redoor", startTime: "13:40", endTime: "14:30"),
                        ArtistSchedule(name: "TELEVISION OFF", image: "televisionoff", startTime: "15:10", endTime: "16:00"),
                        ArtistSchedule(name: "지소쿠리클럽", image: "jisokuriclub", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "오월오일", image: "maymay", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "페퍼톤스", image: "peppertones", startTime: "19:10", endTime: "20:10"),
                        ArtistSchedule(name: "실리카겔", image: "silicagel", startTime: "20:50", endTime: "21:50")
                    ]
                              )
                ],
                "2일차": [
                    ArtistInfo( stage: "Mint Breeze Stage", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "고고학", image: "gogohak", startTime: "12:50", endTime: "13:30"),
                        ArtistSchedule(name: "데이먼스이어", image: "damonsyear", startTime: "14:00", endTime: "14:50"),
                        ArtistSchedule(name: "하동균", image: "donggyun", startTime: "15:30", endTime: "16:20"),
                        ArtistSchedule(name: "멜로망스", image: "melo", startTime: "17:00", endTime: "18:00"),
                        ArtistSchedule(name: "10CM", image: "tencm", startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "홍이삭", image: "isaac", startTime: "20:20", endTime: "21:20")
                    ]
                              ),
                    ArtistInfo(stage: "Club Midnight Sunset", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "LOW HIGH LOW", image: "lowhighlow", startTime: "12:30", endTime: "13:10"),
                        ArtistSchedule(name: "SNAKE CHICKEN SOUP", image: "soup", startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "Wendy Wander", image: "wendy", startTime: "15:10", endTime: "16:00"),
                        ArtistSchedule(name: "THE SOLUTIONS", image: "thesolutions", startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "Dragon Pony", image: "dragonpony", startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "쏜애플", image: "thornapple", startTime: "19:20", endTime: "20:20"),
                        ArtistSchedule(name: "N.Flying", image: "nflying", startTime: "21:00", endTime: "22:00")
                    ]
                              ),
                    ArtistInfo(stage: "Station Stardust",location: "88호수수변무대", artists: [
                        ArtistSchedule(name: "OurR", image: "ourr", startTime: "13:20", endTime: "14:00"),
                        ArtistSchedule(name: "KEN", image: "ken", startTime: "14:30", endTime: "15:10"),
                        ArtistSchedule(name: "범진", image: "beomjin", startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "Michael Kaneko", image: "kaneko", startTime: "17:20", endTime: "18:10"),
                        ArtistSchedule(name: "스텔라장", image: "stella", startTime: "18:50", endTime: "19:40"),
                        ArtistSchedule(name: "너드커넥션", image: "nerdnerd", startTime: "20:20", endTime: "21:20")
                    ]
                              )
                ]
            ],
            days: [
                FestivalDay(dayOfWeek: "토", date: "2026.10.18"),
                FestivalDay(dayOfWeek: "일", date: "2026.10.19")
            ]
        )
    ]
}
