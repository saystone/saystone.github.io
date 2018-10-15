---
title: macOS 환경에 Black(Code formatter for Python) 설치하기
date: 2018-06-18 16:14:31
tags:
  - macOS
  - black
  - Python
  - git hooks
  - pre-commit
  - code formatter
  - pycodestyle
  - PEP 8
---

일전에 PHP 프로젝트에 써봄직한 Code formatter를 소개했습니다. 이번에는 Python 프로젝트에 써볼만한 도구를 소개하려고 합니다. 운영중인 Python 프로젝트는 Python의 문법적 특성으로 인해 PHP 프로젝트보다 상대적으로 깔끔한 코드 베이스를 갖추고 있습니다. 다만, 빠른 기능구현에 집중하다 보니 코딩 컨벤션 측면에선 다소 아쉬운 부분이 있습니다. 조금이라도 일찍 도구를 도입해서 표준화를 시키는게 여러모로 이득이라고 생각하여 리서치를 진행하게 됐습니다.<!-- more -->

이 글을 정리하기 위해 구글링을 하던 중 코딩 컨벤션이 무엇인지, 왜 중요한지, 일관성이 있는 기준이 어떤 이점을 가질 수 있는지 아주 잘 설명한 글을 먼저 소개하고 본론으로 들어가도록 하겠습니다.

- [스포카 기술 블로그](https://spoqa.github.io/): [파이썬 코딩 컨벤션](https://spoqa.github.io/2012/08/03/about-python-coding-convention.html)

---

[Black](https://github.com/ambv/black)을 소개합니다. Black은 Python 언어에서 사용할수 있는 Code formatter입니다. `The uncompromising code formatter.` 라고 소개하고 있는데 다소 엄격해 보이는 문구가 뭔가 마음에 듭니다. 이는 Black이 추구하는 코딩 컨벤션이 개발자가 작성한 코드 스타일과 타협을 하지 않는다고 해석할수 있을것 같아요. 그렇다면, 이 도구는 어떤 코딩 컨벤션을 기준으로 규칙을 정의하는지 궁금해서 소스를 까보았습니다.

Black의 컨벤션 확인 로직은 [pycodestyle](https://github.com/PyCQA/pycodestyle)을 [토대로 구현](https://github.com/PyCQA/pycodestyle/blob/master/pycodestyle.py)되어 있습니다. `pycodestyle`은 Python 언어에서 사용하는 linter라고 볼 수 있는데, 컨벤션 규칙을 [PEP 8](https://www.python.org/dev/peps/pep-0008/)를 기준으로 하고 있습니다. 따라서, Black의 컨벤션 규칙은 `PEP 8`에 맞춰져 있다고 생각하면 될것 같습니다.

---

설치 방법은 매우 간단합니다.

```shell
$ pip install black
```

실행 방법 또한 간단합니다.

```shell
$ black blah.py
```

각종 실행 옵션은 [공식 문서](https://github.com/ambv/black#command-line-options)를 참고하시면 되고 각종 에디터별 플러그인 등은 아래 목록 참고해 주세요!

### Editor plugins for Black
- PyCharm: https://github.com/ambv/black#pycharm
- Vim: https://github.com/ambv/black#vim
- VSCode: https://github.com/ambv/black#visual-studio-code
- Atom: https://atom.io/packages/python-black


### Outro
팀 내 도입 이후 코드가 꽤나 깔끔해졌습니다. 로직을 구현하는 스타일은 다를지언정 코드 스타일링은 어느정도 표준화 되어서 누가 작성해도 일관성 있는 가독성을 보장하게 됐습니다. 가독성이 나아졌기 때문에 코드 읽기가 더 수월해졌고요. 이는 생산성으로 이어지길 기대합니다. 에디터에서 저장하는 시점에 한번 돌리고 커밋 전에 한번 돌리는 식으로 사용하고 있습니다. 클린 코드 하세요! :)


### 참고
- [Black](https://github.com/ambv/black)
- [pycodestyle](https://github.com/PyCQA/pycodestyle)
- [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- [awesome-static-analysis](https://github.com/mre/awesome-static-analysis/)
- [파이썬 코딩 컨벤션](https://spoqa.github.io/2012/08/03/about-python-coding-convention.html)
