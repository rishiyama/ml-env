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

# コンテナの状態を確認
STATUS=$(docker inspect -f '{{.State.Status}}' $CONTAINER_NAME 2>/dev/null)

if [ "$STATUS" == "running" ]; then
    echo "コンテナ '$CONTAINER_NAME' は既に実行中です。"
elif [ "$STATUS" == "exited" ]; then
    echo "コンテナ '$CONTAINER_NAME' は停止しています。再起動します..."
    docker start $CONTAINER_NAME
    echo "コンテナ '$CONTAINER_NAME' が再起動しました。"
else
    echo "コンテナ '$CONTAINER_NAME' は存在しません。run.sh を使用して新たに作成してください。"
fi
