---
title: 커스텀 도커 이미지로 CircleCI 빌드 시간 단축하기
date: 2017-10-18 19:00:00
tags:
  - circleci
  - docker
  - ci
  - build
---

고객이 증가합니다. 비즈니스 요구사항이 다양해집니다. 규모가 커집니다. 서비스의 성장과 함께 자연스럽게 겪는 일입니다. 이런 상황에서 기술적으로 복잡하거나 어려운 문제를 마주하게 되는데 이를 해결하는 것은 곤욕스러울 때도 있지만 대체로 즐거운 경험으로 남아 있었던것 같습니다... (!?) <!-- more -->

---

### Intro
최근 팀 내에서 일부 비즈니스 요구사항을 커버하기 위해 기술적인 도전이라고 볼 수 있는 프로젝트를 진행하기로 결정, 한창 진행 중입니다. DynamoDB의 일부 테이블에 해당하는 데이터는 PostgreSQL에도 함께 적재하도록 처리하는 서버를 만들기로 했는데요. 이런 일련의 과정을 거치는 이유는 DynamoDB로 풀기 힘든 문제들이 당면해 있는 요구사항과 부딪혔기 때문입니다. (RDB에서 어렵지 않게 할 수 있는 통계 및 집계성 쿼리 기능들과 상충합니다.)

이 프로젝트에서 저는 주로 개발 환경을 만드는 일들을 진행해왔습니다. 몇 가지 나열해 보자면 미리 사용하기로 한 기술들을 조합하여 로컬에서 개발 환경으로 프로젝트를 구동할 수 있도록 데이터베이스를 설정하고 애플리케이션 빌드 및 테스팅, 코드단 스케폴딩을 마련하는 것과 프로덕션 환경에 배포하고 모니터링 할 수 있는 기반을 만들거나 CI를 설정하고 설정한 CI와 저장소를 연동하는 일들이었습니다.

---

### Stack that we use
제가 속한 팀에서 운영중인 프로젝트 대부분은 CI를 활용 중이며 CircleCI를 사용하고 있습니다. 서비스간 비동기 처리를 위한 메시지 큐 + 앱 푸시 등을 처리하는 worker, 비즈니스 로직(동적 컨텐츠 반환, 결제 처리, 채팅 연결 등)를 처리하기 위한 GraphQL + 소켓 서버, 고객에게 앱을 제공하기 위한 React Native 클라이언트 등등 대부분 AWS EB + CircleCI + Github 조합으로 빌드, 배포 자동화가 되어 있습니다. 이번에 구축하는 프로젝트 역시 동일한 구성을 사용하기로 했습니다. 종전 프로젝트와 다른 점은 CircleCI 2.0을 사용하는 것인데요. 1.0과 가장 큰 차이는 도커를 native로 지원하는 거라고 볼 수 있을 것 같습니다.

빌드 과정을 간략하게 설명하자면 특정 브랜치가 푸시되면 CircleCI는 해당 저장소의 `.circleci/config.yml` 을 기준으로 빌드를 시작합니다. 빌드가 진행되는 동안 작업자가 PR을 작성하면 다른 동료들의 코드 리뷰를 받게 됩니다. 리뷰가 통과되고 빌드가 성공했다면 비로소 master 브랜치에 머지를 할 수 있도록 머지 버튼이 활성화되고, 작업자가 머지를 하면 CircleCI 가 한 번 더 빌드를 시작하고 배포까지 수행합니다. (배포는 master 브랜치 기준으로만 수행합니다.)

---

### CircleCI with Docker
예상하셨겠지만 `.circleci/config.yml` 파일에는 해당 프로젝트를 빌드하거나 테스트 및 배포를 위한 기반 환경을 설정하고 실행하는 명령들이 있습니다. 이해를 돕기 위해 설정 파일의 변경점를 확인해 보시죠.

![config.yml 의 개선 전/후](/images/circleci-config-diff.png)

좌측이 개선되기 이전의 설정이고, 우측이 개선된 후의 설정입니다. 아무래도 프로젝트가 막 만들어졌고 `awsebcli`를 설치하는 데  필요한 도구들 외에 다른 게 없어서 별게 없습니다. 개선되기 전인 좌측을 먼저 볼까요? 도커 컨테이너를 실행하기 위한 이미지는 CircleCI에서 제공하는 `circleci/node:8.4.0` 를 사용하고 있고 저장소를 `checkout` 한 후 의존하는 패키지를 설치합니다. 이는 실제로 CircleCI 웹 인터페이스에서 확인하면 아래와 같이 동작합니다.

![`Install dependencies` 항목 우측의 27초를 주목해주세요!](/images/circleci-build-before.png)

이번엔 변경점의 우측을 봅시다. 좌측과 달리 도커 이미지를 `huiseoul/alligator:latest` 이걸로 사용할 뿐 다른 의존성 패키지 설치 명령어는 삭제되었습니다. 이미 눈치챈 분들도 있으시겠죠? 맞습니다. 의존성 패키지 설치를 `huiseoul/alligator:latest` 이 도커 이미지 내에 넣었기 때문입니다.

```yml Dockerfile of huiseoul/alligator
FROM        circleci/node:8.8.1

RUN         sudo apt-get update
RUN         sudo apt-get install -y python-pip libpython-dev
RUN         sudo easy_install --upgrade six
RUN         sudo pip install awsebcli
```

![`Install dependencies` 항목이 사라졌습니다.](/images/circleci-build-after.png)

자, 이제 우린 의존성 패키지를 미리 설정해둔 도커 이미지덕에 매 빌드마다 27초를 아끼게 됐습니다. 아이러니하게도 의존성 패키지가 많으면 많을수록 아낄 수 있는 시간이 늘어납니다! 이거야말로 마법 아닙니까!? 더군다나 하루에 빌드하는 횟수까지 고려하면 들이는 노력대비 훌륭한 가성비라고 생각합니다.

---

### Outro
이전부터 도커에 관심만 있었지 실제 사용해 본 적은 없습니다. 로컬 머신에 도커를 설치하고 기본 사용법을 익혀 이 프로젝트에 맞게 의존성 패키지 설치 스크립트가 포함된 Dockerfile을 만들어서 이미지를 생성하고 도커 허브의 개인 및 조직 계정을 만들어 공개 저장소에 업로드 하는것까지 채 1시간도 걸리지 않았습니다. 이제 걸음마 수준으로 사용하는 단계지만 실제로 사용해보니 기대만큼 좋은 인상을 얻을 수 있었던것 같습니다. 만약 다음에 새로운 프로젝트를 진행하거나 사용할수 있는 상황이 된다면 적극 사용하게 될것 같습니다.

---

### 참고
- [Docker Docs](https://docs.docker.com/)
- [CircleCI 2.0 Docs](https://circleci.com/docs/2.0/)