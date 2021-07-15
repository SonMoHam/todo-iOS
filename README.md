# todo-iOS
- 오토레이아웃, alamofire 통신 & JSON 파싱, swipeCellKit, custom tableViewCell 등등..

# 0703 - 0705

![스크린샷 2021-07-05 오후 5 42 00](https://user-images.githubusercontent.com/73145656/124443718-df006c80-ddb8-11eb-8958-dc9619e53521.png)
![스크린샷 2021-07-05 오후 5 45 57](https://user-images.githubusercontent.com/73145656/124443728-e0ca3000-ddb8-11eb-98de-c3fd84fa96a7.png)

todo-server 연결,
get post 요청 / 기능 구현

---

# 0706

![스크린샷 2021-07-06 오후 7 13 00](https://user-images.githubusercontent.com/73145656/124583638-3e7c7c00-de8e-11eb-9b86-64e090e9c3a0.png)


SwipeCellKit 적용,
완료 여부와 기한에 따른 상태 표시 / 완료 미완 기한초과 기한임박(오늘까지)
put todoIsClear:id 메소드 요청 적용

예정
- 완료 여부에 따른 left swipe action 분기 처리 ex) 완료 처리, 미완 처리
- right swipe action : 수정 , 삭제 기능 추가

---

# 0707 기능 완성

![todo-ios](https://user-images.githubusercontent.com/73145656/124736804-5584a200-df52-11eb-898e-2f435147711d.gif)


이후 예정
- 코드 리팩토링 예정
- mvc 또는 mvvm 등 디자인 패턴 적용 예정

---

# 0711


TodoAlamofireManager, TodoRouter 추가
