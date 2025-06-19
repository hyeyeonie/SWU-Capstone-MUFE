# 나의 뮤직페스티벌 프렌즈, MUFE
안녕하세요. 서울여자대학교 캡스톤디자인설계1의 팀 기상청입니다🌈

![Image](https://github.com/user-attachments/assets/9f2dc913-2ee7-4310-b23d-fffd31a020d6)

## 1. 프로젝트 소개

#### "뮤프가 당신의 취향에 꼭 맞는 타임테이블을 추천해 드려요!"

MUFE의 서비스 가치는 「실패 없는 뮤직페스티벌 경험을 제공하는 것」입니다.

뮤직페스티벌을 혼자 즐기러 가는 관객이 수많은 무대가 동시에 펼쳐지는 현장에서 무엇을 봐야 할지 망설이는 사이에 놓쳐버리는 무대가 없도록

**사용자의 음악 취향을 기반으로 하여** 타임테이블을 추천해 줌으로써 실패 없는 페스티벌을 즐기고 싶은 욕구를 충족시켜 주고자 합니다.




## 2. 개발 환경

(1). ⚒️ Front-end : Xcode, Swift UI, UIKit

(2). ⚙️ Back-end :  Swift Data, OpenAi(Chat GPT) API, 공연예술통합전산망 API

(3). 📁 버전 및 이슈 관리: Github, Github Issues, Github Project

(4). 📱 서비스 배포 환경 : iOS App Store

(5). 🎨 Design : Figma

(6). 🧩 협업: Notion, Discord




## 3. 프로젝트 구조

~~~~

📁 Mufe
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Assets.xcassets
│   ├── AccentColor.colorset
│   ├── AppIcon.appiconset
│   ├── artistImg.imageset
│   ├── check.imageset
│   ├── Contents.json
│   ├── Day1
│   ├── Day2
│   ├── Day3
│   ├── FestivalPoster
│   ├── fstImg.imageset
│   ├── Gray
│   ├── loading.imageset
│   ├── mufe.imageset
│   ├── Primary
│   ├── ticketLine.imageset
│   └── ticketLine2.imageset
├── Config.xcconfig
├── Extension
│   ├── Color+.swift
│   ├── Font+.swift
│   └── UIVIew+.swift
├── Info.plist
├── Network
│   ├── DTO
│   ├── FestivalPromptBuilder.swift
│   ├── GetInfoService.swift
│   └── NetworkError.swift
├── Presentation
│   ├── Cell
│   ├── Model
│   ├── OnboardingViewController.swift
│   ├── PersonalTimetableViewController.swift
│   ├── View
│   └── ViewController.swift
└── Resource
    └── Font

~~~~

## 4. 팀원 소개

|☁️구름|☁️최하늘|☁️신혜연|☁️윤솔비|
|---|---|---|---|
|<img src="https://github.com/user-attachments/assets/faf344a1-e75a-4628-8524-ac76e9a6ba6a" width="120" height="120" />|<img src="https://github.com/user-attachments/assets/a23729a0-e158-43e4-b613-08d645b00036" width="120" height="120" />|<img src="https://github.com/user-attachments/assets/33dfbcc6-1db9-43ff-8ca4-889be3b4190d" width="120" height="120" />|<img src="https://github.com/user-attachments/assets/9588eb2e-6e7d-4b80-b1f6-02895eefd6c8" width="120" height="120" />|
|GUI 설계, 기획|UX 설계, 기획|개발 전체, 기획|기획, AI프롬프팅|
