---
title: React Native를 iOS로 실행했을때 `Could not parse the simulator list output` 에러 해결 방법
date: 2018-04-03 18:00:00
tags:
  - React Native
  - XCode
---

여느때처럼 iOS 시뮬레이터에서 확인하기 위해 아래와 같은 명령어를 실행했더니 처음보는 에러를 만났습니다. <!-- more -->

```shell
$ npx react-native run-ios
Scanning folders for symlinks in /Users/saystone/Projects/hsMobile/node_modules (15ms)
Found Xcode workspace 惠首尔.xcworkspace
dyld: Symbol not found: _SimDeviceBootKeyDisabledJobs
  Referenced from: /Applications/Xcode.app/Contents/Developer/usr/bin/simctl
  Expected in: /Library/Developer/PrivateFrameworks/CoreSimulator.framework/Versions/A/CoreSimulator
 in /Applications/Xcode.app/Contents/Developer/usr/bin/simctl

Could not parse the simulator list output
```

보통 못보던 에러를 만나게 되면 구글링 전에 우선적으로 시도해보게 되는 것들이 있습니다. 이것들은 빠르게 시도해보고 바로 확인해볼수 있어야 의미가 있다고 생각하기 때문에 얼른 시도해보고 소득이 없다는게 판단되면 바로 구글링을 하는 편이죠. 이번의 경우엔 빌드는 시작도 못했고 시뮬레이터가 실행되기 전에 환경적인 요인으로 발생한 문제라고 예상했습니다. 경험상 캐시를 비우거나 의존성 패키지를 다시 설치하는 것만으로도 해결되는 경우가 있죠. 따라서 RN이나 npm에서 사용하는 도구들의 캐시를 비우고 다시 설치하는걸 시도해보았지만 실패했습니다.

바로 구글링을 해보았습니다. 그랬더니 XCode를 실행해서 추가로 요구되는 필수 컴포넌트를 설치하면 해결된다는 글을 보게 되었습니다. 조금 의아했지만 XCode를 실행했습니다. `Install additional required components?` 라고 물어봅니다. 설치 버튼을 누르고 잠시 기다리니 설치가 끝났습니다. 다시 터미널로 돌아와서 위의 명령어를 실행했더니... 잘 됩니다.

가만 생각해보니 XCode와 관련해서 간혹 이런 비슷한 경험을 했던것 같습니다. 가령 macOS 내에서 사용하는 특정 개발 도구나 SDK 들을 설치하거나 실행할때 `Command Line Tools for XCode`를 먼저 설치 하지 않거나 XCode를 한번이라도 실행하지 않으면 더 이상 진행이 안됐던적이 있었던 기억이 있네요.

### 참고
- [watchman + RN 캐시 + npm 캐시 삭제하고 재설치 한방에](https://gist.github.com/saystone/10fd1c52dc4da80c334534f58593bdaa)
- [Resolving "Could not parse the simulator list output" when running React Native apps on iOS Simulator]( https://joelennon.com/resolving-could-not-parse-the-simulator-list-output-when-running-react-native-apps-on-ios-simulator)








