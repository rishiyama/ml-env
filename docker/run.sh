#!/bin/bash

# デフォルト設定
IMAGE_NAME="my_image_name"  # Dockerイメージ名
CONTAINER_NAME="my_container"            # コンテナの名前
HOST_PORT=8888                                    # ホストで公開するポート
WORKSPACE_DIR=$(pwd)                              # ホスト側の作業ディレクトリをマウントする先
JUPYTER=false                                     # Jupyter Notebookを起動するかどうか

# 引数処理
while getopts i:n:p:j flag
do
    case "${flag}" in
        i) IMAGE_NAME=${OPTARG};;         # -i イメージ名を指定する
        n) CONTAINER_NAME=${OPTARG};;     # -n コンテナ名を指定する
        p) HOST_PORT=${OPTARG};;          # -p ホストの公開ポートを指定する
        j) JUPYTER=true;;                 # -j Jupyter Notebookを起動する
    esac
done

# 既存のコンテナが存在するか確認し、存在する場合は削除
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "既存のコンテナ '$CONTAINER_NAME' を削除します..."
    docker rm -f $CONTAINER_NAME
fi

# Jupyter Notebookのコマンド設定
if $JUPYTER; then
    CMD="jupyter notebook --ip=0.0.0.0 --port=$HOST_PORT --no-browser --allow-root"
else
    CMD="tail -f /dev/null"
    # CMD="/bin/bash"
fi

# コンテナを起動する
docker run --name $CONTAINER_NAME -d --gpus all \
  --init \
  --rm \
  --ipc=host \
  -p $HOST_PORT:8888 \
  -v "$WORKSPACE_DIR":/workspace \
  -w /workspace \
  $IMAGE_NAME $CMD

echo "コンテナ '$CONTAINER_NAME' が起動しました。Jupyter Notebookが使える場合は http://localhost:$HOST_PORT でアクセスできます。"
