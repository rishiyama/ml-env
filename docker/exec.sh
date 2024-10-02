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

# コンテナが実行中か確認
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker exec -it $CONTAINER_NAME /bin/bash
else
    echo "エラー: コンテナ '$CONTAINER_NAME' は実行中ではありません。"
    echo "まずは run.sh でコンテナを起動してください。"
fi
