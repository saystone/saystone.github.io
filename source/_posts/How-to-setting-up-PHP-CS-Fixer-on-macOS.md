---
title: macOS 환경에 PHP-CS-Fixer 설치하기
date: 2018-06-11 09:45:30
tags:
  - macOS
  - PHP
  - lint
  - phpbrew
  - git hooks
  - pre-commit
  - code formatter
  - PHP CS Fixer
  - PSR
---

최근, 꽤나 방대하고 복잡한 코드베이스로 이뤄진 PHP 프로젝트를 접하게 되었습니다. 구형 솔루션을 다년간에 걸쳐 커스터마이징한 형태의 프로젝트로, 여러 개발자가 거쳐간 흔적이 코드에 고스란히 남아 있습니다. 프로덕션 레벨에서 돌아가는 버전도 무려 9년전에 릴리즈된 `5.2.17` 이었으며 방대한 코드량에 비해 코드의 품질 관리를 신경쓸만한 상황이 아니었던지 레거시 코드의 가독성이 매우 절망적인 상황이었습니다. 한 파일에 들여쓰기가 2탭 4탭이 공존하고 탭과 스페이스가 섞여있으면 절망적인 상황... 맞죠?<!-- more -->

사태파악 이후 개선의 여지로 무엇보다 코딩 컨벤션을 표준화 시켜야할 필요가 있다고 느꼈습니다. 우선적으로 시작해 볼 수 있는것 중 제일 빠르게 떠올랐던건 앞으로 작성하는 코드라도 linter를 적용 해보는 것이었습니다. 그러다 [PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)라는 도구를 알게 됐고 더불어 [PSR](https://github.com/php-fig/fig-standards)이라는게 존재한다는걸 알게 됐습니다.

`PHP-CS-Fixer`는 특정 코딩 표준을 지키도록 기존 코드를 고쳐주는 도구입니다. 위에서 언급한 `PSR-*` 또는 커뮤니티에서 주도하는 다른 표준 프리셋을 지정하거나 직접 만든 설정을 적용할수도 있습니다.

linter 보다는 좀 더 나아 보이는 대안이다 싶어 리서치를 진행하여 팀에 제안, 긍정적인 피드백을 받았고 약 한달 전에 팀 내 모든 개발자들이 사용할수 있도록 메뉴얼을 만들고 배포했으며 지난주부터 각자 개발 환경에 도입하여 현재는 잘 사용하고 있습니다! :)

---

### Getting started
PHP-CS-Fixer를 실행하려면 PHP 버전 5.6 이상이 필요합니다. 따라서 PHP를 먼저 설치해야 하는데요. PHP를 설치하기 전에 PHP 버전 관리 도구를 먼저 설치하고자 합니다. 그런데 PHP 버전 관리 도구를 설치하려면 다른... 아...아닙니다;

---

### PHP 버전 관리 도구 설치
  - 요즘 왠만한 언어에는 언어의 버전을 관리할수 있는 도구가 대부분 있습니다. PHP도 마찬가지고 그 중 [phpbrew](https://github.com/phpbrew/phpbrew)라는 도구가 있는데 이를 설치하고자 합니다.

```shell installing phpbrew https://github.com/phpbrew/phpbrew#install
# 설치 패키지를 받고 실행 권한을 부여합니다.
$ curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
$ chmod +x phpbrew

# $PATH에 지정되어 어디서든 실행할수 있는 곳으로 이동합니다.
$ sudo mv phpbrew /usr/local/bin/phpbrew

# phpbrew를 초기화합니다.
$ phpbrew init
```

  - 터미널 시작마다 실행하기 위해 `.bashrc` 또는  `.zshrc`에 아래 한줄 추가하고 터미널을 재실행합니다.

```shell
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc
```

---

### PHP 설치
  - PHP `5.6`의 마지막 stable 버전인 `5.6.36`을 설치하고자 합니다.
  - 굳이 `5.x`일 필요는 없습니다! `5.x`와 `7.x`의 환경이 꽤 다르므로 최소 요구 사항에만 맞추려고 했고 프로덕션에도 `5.2.17`을 사용해서 여기서는 `5.x`를 선택했습니다.
```shell installing PHP 5.6.36 via phpbrew
# 설치 전에 필요한 몇가지 패키지를 설치합니다.
$ brew install mcrypt mhash libxml2 pcre

# phpbrew로 PHP 5.6.36 설치(빌드하고 컴파일하는데 시간 좀 걸립니다)
$ phpbrew install 5.6.36 +default

# PHP 기본 버전을 5.6.36으로 설정
$ phpbrew switch 5.6.36

# PHP 버전 확인
$ php -v
PHP 5.6.36 (cli) (built: May 11 2018 14:21:46)
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
```

---

### 준비 끝!
  - PHP 파일에 적용해봅시다.
```shell
# PHP 인터프리터로 실행
$ php /usr/local/bin/php-cs-fixer fix ~/Projects/my_project/hello.php

# 혹은 직접 실행
$ php-cs-fixer fix ~/Projects/my_project/hello.php
```
  - 위 명령어 실행하면 바뀐 컨벤션으로 파일을 덮어 쓰게됩니다. diff로 바뀐 내용을 확인해 봅니다.
  - 컨벤션 지정, 디버깅 모드, dry-run 등 다양한 옵션이 있습니다. [공식 문서](https://github.com/FriendsOfPHP/PHP-CS-Fixer#usage)를 확인해서 본인 혹은 팀에 잘 맞도록 셋팅해 줍니다.

---

좋습니다. 아주 좋아요. 심신이 안정되고 마음의 정화가 찾아오는것 같습니다. 그런데 하나 걸리는게 있습니다. 파일이 바뀔때마다 터미널에 저 명령어를 치려고 여기까지 온게 아니잖아요~? 사용하고 있는 에디터 혹은 `git`의 `pre-commit` [hook](https://githooks.com/)을 사용해서 앞으로 더 신경쓰지 말도록 해요. 깔끔한 마무리를 위해 좀 더 시간을 투자해 봅시다.

---

### Git pre-commit hook 설정
  - https://gist.github.com/saystone/6ae86685f34d632c37a98fc4d36b74d2#file-pre-commit-php 내용을 그대로 복사합니다. (혹은 참조해서 취향대로 수정하세요.)
  - 가져온 내용을 `~/Projects/my_project/.git/hooks/pre-commit` 파일에 넣고 실행권한을 줍니다.

```shell grant executable authority
$ chmod +x ~/Projects/my_project/.git/hooks/pre-commit
```

  - 이제 앞으로 커밋을 할때마다 자동으로 `pre-commit` 파일 내의 스크립트가 실행됩니다. 실패한경우 커밋을 멈추고 알려줍니다!
  - 예외적으로 hook을 거치지 않고 커밋을 하고싶다면 아래 명령어를 사용하면 됩니다.

```shell ignore hook
$ git commit --no-verify
```

---

### 각종 에디터에 설정
  - `git`의 `pre-commit`을 사용하는 방법이 별로라면 본인이 사용하는 에디터에 설정하는 방법도 있습니다.
  - 파일을 저장하고 난 후에 자동으로 실행 되도록 하면 딱일것 같네요.
  - VSCode: https://github.com/junstyle/vscode-php-cs-fixer
  - Atom: https://atom.io/packages/php-cs-fixer
  - Vim: https://github.com/stephpy/vim-php-cs-fixer
  - PHPStorm: https://hackernoon.com/how-to-configure-phpstorm-to-use-php-cs-fixer-1844991e521f

---

### 참고
  - [PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)
  - [PHP Framework Interoperability Group](https://github.com/php-fig/fig-standards)
  - [phpbrew](https://github.com/phpbrew/phpbrew)
  - [Git Hooks](https://githooks.com/)
