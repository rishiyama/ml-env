#!/bin/bash

# デフォルト設定
CONTAINER_NAME="my_container"

# 引数処理
while getopts n: flag
do
    case "${flag}" in
        n) CONTAINER_NAME=${OPTARG};;     # -n コンテナ名を指定する
    esac
done

# コンテナを停止・削除
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker stop $CONTAINER_NAME
    echo "コンテナ '$CONTAINER_NAME' が停止されました。"
elif [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    docker rm $CONTAINER_NAME
    echo "コンテナ '$CONTAINER_NAME' が削除されました。"
else
    echo "コンテナ '$CONTAINER_NAME' は存在しません。"
fi
