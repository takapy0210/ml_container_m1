# Machine Learning Container for M1 Max

M1 Mac対応のデータ分析用のコンテナイメージです。  
2021/11/13 時点においては、requirements.lockファイルを使用していません。  
（tensorflowが特殊な形式でしかインストールできないため）
念の為、2021/11/13 時点のpip freezeしたものを`requirements.lock`には出力してあります。

## How to use

1. コンテナのビルド&起動  
```sh
# ビルド（初回は結構時間かかります...）
$ docker compose build

# jupyterの起動
$ docker compose up -d ml-jupyter
```

2. ブラウザから`http://127.0.0.1:8900/lab`にアクセス  
`password`の文字列を入力するとjupyterが使えます

## Install or Update Library

1. ライブラリのインストール or アップデートを行う  
    - インストールする際はdockerコンテナ内で`pip3 install`等を行う
2. 後述の手順で`requirements.lock`（or Dockerfile）を更新する  
3. ローカル環境でコンテナがビルドできること、jupyter及びインストールしたライブラリが正しく動作することを確認する  
```sh
$ docker compose build
$ docker compose up -d ml-jupyter
```

## requirements.lock の生成方法

1. コンテナに入る  
```sh
# 起動中の場合
$ docker exec -it <コンテナ名またはコンテナID> /bin/bash

# 停止中の場合
$ docker run -it <コンテナ名またはコンテナID> /bin/bash
```

2. （ライブラリを追加・アップデートする場合は）pip installなどを行う  
```sh
$ pip3 install hogehoge
```

3. freeze  
```sh
$ pip3 freeze > requirements.lock

# 出力されていることを確認
$ ls
>> requirements.lock

# shellから抜ける
$ exit
```

4. ホストにコピー  
カレントディレクトリにコピーされる
```sh
$ docker cp <コンテナID>:/opt/program/working/requirements.lock requirements.lock
```

## ローカルのマウントディレクトリを増やす場合

docker-compose.ymlの`volumes`に追記してください
```yaml
volumes:
    - ホストのマウント元:コンテナ内のマウント先:cached
    - ./working:/opt/program/working:cached
```
