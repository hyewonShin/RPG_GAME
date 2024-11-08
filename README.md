# 프로젝트 소개 
콘솔로 실행하여 사용할 수 있는 전투 RPG 게임입니다 🗡️
<br/><br/>


# 개발기간
2024.11.04~2024.11.07
<br/><br/>


# 개발환경
Dart sdk: ^3.5.4
<br/><br/>


# 실행방법
dart run lib/main.dart
<br/><br/>


# 주요기능
### 기본
- 사용자에게 캐릭터 이름을 입력받는 기능
  - 정규식을 사용하여 한글, 영문 대소문자만 가능
- File 라이브러리 사용
  - charactor.txt 파일과 monster.txt 파일에서 캐릭터와 몬스터 정보 불러오는 기능 
  - 게임의 승패를 result.txt 파일에 저장하는 기능   
- 한 턴마다 캐릭터와 몬스터의 상태(체력,공격력,방아력)을 출력하는 기능
- 캐릭터는 몬스터 리스트에서 랜덤으로 뽑힌 몬스터와 대결하는 기능
- 캐릭터가 몬스터를 공격하는 기능
  - 데미지 = 캐릭터의 공격력 - 몬스터의 방어력
- 캐릭터가 몬스터를 방어하는 기능
  - 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력이 상승됨
- 몬스터가 캐릭터를 공격하는 기능
  - 데미지 = 몬스터의 공격력 - 캐릭터의 방어력
  - 몬스터의 공격력은 캐릭터의 방어력보다 크고 몬스터 최대 공격 범위보다 작은 랜덤값
- 물리친 몬스터는 몬스터 리스트에서 제거하는 기능 
- 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 승리하는 기능
- 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택하는 기능
- 캐릭터의 체력이 0 이하가 되면 게임이 종료되는 기능

### 도전
- 게임이 시작되고 30%의 확률로 캐릭터에게 보너스 체력을 제공하는 기능
- 캐릭터가 전투 중에 한 번 특수 아이템을 사용할 수 있는 기능
  - 아이템을 사용했다면 다시 사용할 수 없도록 처리
  - 아이템 사용 시 캐릭터는 공격력이 두 배로 변경
- 몬스터의 방어력 증가 기능
  - 3턴마다 몬스터의 방어력이 2씩 증가
  - 방어력 증가로 인하여 캐릭터가 몬스터에게 입히는 데미지가 감소함

### 추가 
- 명예의 전당 기능
  - result.txt 파일에 승패 결과가 누적 되도록 함
  - 승리한 캐릭터 중에서 체력이 가장 높은 명예 영웅 선발
  - 게임 실행 시 가장 위에 해당 영웅 출력 되도록 함
- chalkdart 라이브러리 사용하여 특정 텍스트에 색상 추가하여 가독성 높임
<br/><br/>


# 프로젝트 미리보기 
![image](https://github.com/user-attachments/assets/e0a73397-cb86-49b9-9022-fd9ca8b094db)
-
![image](https://github.com/user-attachments/assets/539ae3db-23f3-4f37-bdb7-8bfe39103047)


