---
title: React Native 앱을 iOS로 실행했을때 `Could not parse the simulator list output` 에러 해결방법
date: 2018-04-04 17:25:00
tags:
  - React Native
  - XCode
  - xcrun
  - simctl
---

여느때처럼 RN으로 만들어진 앱 디버깅을 하기위해 iOS 시뮬레이터를 아래와 같은 명령어로 실행했습니다. 그러다 처음보는 에러를 만나게 되었습니다. <!-- more -->

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

---

### When I meet the error. I am...
보통 처음보는 에러를 만나게 되면 구글링 전에 우선적으로 시도해보게 되는 것들이 있습니다. 이것들은 빠르게 시도해보고 바로 확인해볼수 있어야 의미있기 때문에 얼른 시도해보고 소득이 없으면 지체없이 구글링을 합니다. 이번의 경우엔 빌드는 시작도 못했고 시뮬레이터가 실행되기도 전에 환경적인 요인으로 발생한 문제라고 예상했어서 경험상 캐시를 비우거나 의존성 패키지를 다시 설치하는 것만으로도 해결되는 경우가 있습니다. 따라서 RN이나 npm에서 사용하는 도구들의 캐시를 비우고 다시 설치하는걸 시도해보았지만... 해결되지 않았습니다.

### Problem solved! but...
바로 에러 메세지로 구글링을 해보았습니다. 그랬더니 XCode를 실행해서 추가로 요구되는 필수 컴포넌트를 설치하면 해결된다는 글을 보게 되었습니다. 조금 의아했지만 XCode를 실행했습니다. `Install additional required components?` 라고 물어봅니다. 설치 버튼을 누르고 잠시 기다리니 설치가 끝났습니다. 다시 터미널로 돌아와서 위의 명령어를 실행했더니... 잘 됩니다.

### xcrun simctl
해결은 했지만 궁금증은 풀리지 않습니다. XCode의 필수 컴포넌트를 설치하지 않은것과 위의 에러가 어떤 상관관계가 있는지에 대해서 말이죠. 그래서 RN 소스 코드를 살펴보기로 합니다. 위 에러는 RN의 CLI에서 발생한 것이니 RN repository에 가서 뒤져보면 뭔가 나오겠거니 싶었죠. 무식하게 에러 메세지를 repository 내에서 검색했더니 결과 하나가 딱 나옵니다.
```javascript xcrun simctl list --json devices  https://github.com/facebook/react-native/blob/2ad34075f1d048bebb08ef30799ac0d081073150/local-cli/runIOS/runIOS.js#L103-L109
    try {
      var simulators = JSON.parse(
      child_process.execFileSync('xcrun', ['simctl', 'list', '--json', 'devices'], {encoding: 'utf8'})
      );
    } catch (e) {
      throw new Error('Could not parse the simulator list output');
    }
```
코드를 보아하니 `simulators`라는 변수에 `xcrun`이라는 명령어에 특정 인자를 던져 child process로 실행시켜 JSON으로 출력되는 결과를 담는건가 봅니다. 짐작하기로는 iOS 디바이스의 목록을 가져오려는것 같은데 일단 `xcrun`의 정체가 궁금했습니다.
```shell
$ man xcrun
...생략
DESCRIPTION
       xcrun provides a means to locate or invoke developer tools from the command-line, without requiring users to modify Makefiles or other-
       wise take inconvenient measures to support multiple Xcode tool chains.
...생략
```
라고 합니다. command line에서 XCode와 관련된 도구들을 편하게 실행할수 있는 도구 정도로 이해했습니다. 좀 더 깊이 들어가기 위해 직접 명령어를 실행해봅니다. 뭐 안될것 있나요-?
```shell
$ xcrun simctl list --json devices
{
  "devices" : {
    "com.apple.CoreSimulator.SimRuntime.iOS-10-3" : [
      {
        "state" : "Shutdown",
        "availability" : " (unavailable, runtime profile not found)",
        "name" : "iPhone 5",
        "udid" : "D37B8124-786F-40F3-96E5-4E38AC350044"
      },
...생략
```
어떤 기준인지는 모르겠지만 제가 알고있는 모든 애플 기기의 시뮬레이터 목록이 출력되었습니다. 예측한대로 iOS 디바이스의 목록과 연결 상태를 가져오는 명령어가 맞는것 같습니다. JavaScript 코드단에서는 이 명령어를 `try/catch` 블럭 내에서 `JSON.parse`를 사용하여 JSON string -> object 파싱을 시도했는데 파싱에 실패해서 예외가 발생해 `Could not parse the simulator list output`를 던지고 종료한겁니다. 그렇다면 `xcrun simctl` 실행 시점(`npx react-native run-ios`를 실행했을 때)에 JSON string이 아닌 뭔가 다른게 출력되었다는 얘기가 됩니다. 그 메세지가 뭔지 너무 궁금한데 지금으로선 알 방법이 없습니다. `xcrun`의 소스가 공개되어 있는것도 아니고 그 상황을 재현하기도 어려울뿐더러 `xcrun simctl`을 실행했을때 발생하는 에러에 대해서도 구글링 해보았지만 딱히 없었습니다. (몇몇 유추되는게 있지만 그게 이건지는 모르겠더라고요.) 아무튼, 추측하기로는 아마 XCode와 관련된 내용이 아닐까 합니다. 좀 찝찝하지만 여기에 더 시간을 쏟을순 없어서 이정도로 정리하기로 했습니다. 다만, 다음에 또 이 에러를 만나면 꼭 알아내고야 말겁니다. (아마도 XCode의 필수 컴포넌트가 새로 업데이트 되는 시점이겠죠?)

### Outro
가만 생각해보니 XCode와 관련해서 간혹 이런 비슷한 경험을 했던것 같습니다. 가령 macOS 내에서 사용하는 특정 개발 도구나 SDK 들을 설치하거나 실행할때 `Command Line Tools for XCode`를 먼저 설치 하지 않거나 XCode를 한번이라도 실행하지 않으면 더 이상 진행이 안됐던적이 있었던 기억이 있네요.


### 참고
- [watchman + RN 캐시 + npm 캐시 삭제하고 재설치 한방에](https://gist.github.com/saystone/10fd1c52dc4da80c334534f58593bdaa)
- [Resolving "Could not parse the simulator list output" when running React Native apps on iOS Simulator]( https://joelennon.com/resolving-could-not-parse-the-simulator-list-output-when-running-react-native-apps-on-ios-simulator)
- [Could not parse the simulator list output](https://github.com/facebook/react-native/blob/2ad34075f1d048bebb08ef30799ac0d081073150/local-cli/runIOS/runIOS.js#L103-L109)







