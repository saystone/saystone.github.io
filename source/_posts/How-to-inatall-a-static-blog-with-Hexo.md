---
title: How to inatall a static blog with Hexo
date: 2017-02-13 17:31:28
tags:
---
- 이 글에서 알 수 있는 것: Hexo를 선택하게 된 계기, Hexo의 기본 설치 방법과 간단한 사용 방법. 
- 이 글에서 알 수 없는 것: [Github Pages](https://pages.github.com/)에 연동하고 글을 발행 하는 방법, 각종 기본 설정과 테마를 적용하는 방법



평소에 알던 정적 블로그 엔진이라곤 [Jekyll](https://jekyllrb-ko.github.io/) 밖에 없었는데 기술적으로 무언가를 골라야하는 상황이 되면 더 나은게 있는지 꼭 찾아보는 성격이라 관심을 갖고 이미 정적 블로그를 운영중인 지인들에게 추천을 받거나 검색을 하니 다양한 엔진들이 있었는데 결과적으로 [Hexo](https://hexo.io/ko/) 를 사용하기로 했다. <!-- more --> 다른 유명한 블로그 엔진보다 (상대적으로) 설치&사용법이 간단해 보였고, Node.js 기반이고, 근 2년간 주로 Node.js를 사용한게 크게 작용했다. (이후 [StaticGen](https://www.staticgen.com/) 이라는 사이트를 발견해서 결정을 번복 할 뻔 했지만, 이미 템플릿이나 환경설정 등을 모두 마친 상태에서 발견했으므로 더 이상의 고민은 하지 않는걸로!)


1. 아래 내용은 Node.js, Yarn, Git이 로컬에 설치돼 있다는 가정하에 설명한다.
2. 다른 정적 블로그 퍼블리싱 도구들이 그렇 듯 Hexo도 CLI 기반이다.  `hero-cli` 패키지를 `global`로 설치하자.
```shell
$ yarn global add hexo-cli
```
3. Hexo 구동에 필요한 기본 파일들을 설치한다. 직접 디렉토리를 만들거나 특정 디렉토리에 바로 설치할 수 있다. (설치되는 디렉토리, 파일들이 어떤 역할을 하는지 확인하려면 [여기](https://hexo.io/ko/docs/setup.html)를 참고.)
```shell
$ hexo init // 현재 디렉토리에 초기화
$ hexo init saystone // 또는 saystone 디렉토리를 생성하고 그 안에 초기화
```
4. 여느 블로그 엔진들이 그렇듯 구동에 필요한 모듈들을 설치한다.
```shell
$ yarn
```
5. 준비가 다 됐으니 서버를 올려보자.
```shell
$ hexo serve -o
```
6. 곧 브라우저가 열리면서 설치한 블로그를 띄워준다. 친절하게도 포스트 작성, 서버 구동, 정적 파일 생성 및 원격 사이트에 배포하는 방법을 알려주는 포스트를 샘플로 제공하지만, 실제로 뭔가를 하려면 이것보다 더 이것저것 설정해야 하겠다. :)


### 참고
---
- [Hexo Official Documentation](https://hexo.io/ko/docs/)
- [originerd님의 Hexo 설정기](https://originerd.github.io/2017/01/21/how-i-set-hexo/)



