---
title: Git 의 submodule 을 사용하여 Hexo 에 테마 추가하기
date: 2017-04-04 18:04:35
tags:
  - hexo
  - theme
  - even
  - submodule
  - git
---

언젠가 Git을 사용하면서 그런 적이 있다. 내 저장소의 특정 위치에 다른 저장소를 연결하는 방법은 없을까? 간혹 그런 생각이 들 때마다 있겠거니 하고 그냥 넘어갔었는데 마침 이번에 Hexo 를 설치하고 테마를 설정하다 보니 딱 필요한 상황이 생겨서 정리해본다. <!-- more -->

---

### submodule?

> A submodule allows you to keep another Git repository in a subdirectory of your repository. The other repository has its own history, which does not interfere with the history of the current repository. This can be used to have external dependencies such as third party libraries for example.

내 저장소의 특정 subdirectory에 다른 Git저장소를 유지해 주고 커밋 히스토리는 각각 따로 관리하게 된다고 이해하면 될 것 같다. (간단하게 리눅스 쉘의 symbolic link를 떠올리면 될 듯)

---

### Hexo 테마 설치

Hexo 내부적으로 [테마를 기본적으로 지원](https://hexo.io/docs/themes.html)하고 어떤 종류의 테마가 퍼블리싱 되어 있는지 [확인](https://hexo.io/themes/)도 할 수 있다. 개인적으로 모던하고 심플하고 감성적이면서 확장성 있고 다양한 디바이스를 지원하는(어디서 많이 본 문구 같다...?) 테마를 찾고 있었기 때문에 고르고 골라 [Even](https://github.com/ahonn/hexo-theme-even)이라는 테마를 선택하게 됐다. 테마를 선택했으니 본격적으로 설정해 보자.

1. 설치할 테마의 저장소 URL을 기억해 둔 다음 로컬의 저장소 루트로 이동해서 Git 명령어를 써서 submodule을 추가하자. 마지막 인자는 submodule을 설정할 경로.
```shell
$ git submodule add https://github.com/ahonn/hexo-theme-even themes/even
```
2. 별 문제가 없다면 해당 저장소를 클론 받는걸 볼 수 있고 루트에 `.gitmodules` 파일이 생성되며 `./themes/even` 디렉토리가 생성된걸 `git status`로 확인할 수 있다. 
3. 이제 Hexo 에 `나 이 테마 쓸거야~` 하고 알려줘야 한다. 루트의 `_config.yml`을 열어서 `theme` 속성의 값을 `even`으로 수정하고 로컬에서 서버를 올려보자.
```shell
$ hexo s -o
```
4. 곧 브라우저가 열리고 테마가 잘 반영된걸 확인했다면 커밋 & 푸시로 마무리하자.
```shell
$ git commit -m 'feat: add `even` theme' && git push origin hexo
```
5. Github으로 발행까지 하면 리모트에 테마가 반영된걸 확인해 볼수 있다!
```shell
$ hexo deploy
```
6. 추가로 해당 테마에서 지원하는 여러 가지 부가적인 기능들이 있는데 테마 자체적으로 지원하는 기능 외에도 Hexo에서 지원하는 플러그인 기능까지 활용하고 있다. (SCSS renderer, 본문 검색 등) 자세한 내용은 위키에서 확인할 수 있는데 중국어의 압박이 있으니 인내심을 갖고 설정하자. (같은 메뉴를 몇 번째 클릭하는지…ㅠㅠ)
7. 추후 다른 환경에 자신이 만든 저장소를 클론해야 할 일이 생길 텐데 단순히 클론만 받으면 하위 경로에 있는 submodule까지 클론하지 않는다. 아래 명령어를 사용하여 해결하자.
```shell
$ git submodule update --init --recursive
```

---

### 참고
- [Git submodule](https://git-scm.com/docs/git-submodule#_description)
- [Git submodule(한글)](https://git-scm.com/book/ko/v2/Git-%EB%8F%84%EA%B5%AC-%EC%84%9C%EB%B8%8C%EB%AA%A8%EB%93%88)
- [쉽게 모든 submodule 을 pull 받는 방법](http://stackoverflow.com/questions/1030169/easy-way-pull-latest-of-all-submodules)
- [Even 테마 위키](https://github.com/ahonn/hexo-theme-even/wiki)


