FROM python:3.9

LABEL multi.version="1.0" multi.maintainer="takapy <takanobu.030210@gmail.com>"

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE

RUN apt-get -y update && apt-get install -y --no-install-recommends \
        curl \
        sudo \
        graphviz-dev \
        graphviz \
        mecab \
        libmecab-dev \
        mecab-ipadic \
        mecab-ipadic-utf8 \
        git \
        wget \
        g++ \
        make \
        cmake \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Timezone jst
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# nodejsの導入
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
    && sudo apt-get install -y nodejs

# ipadic-neologdの導入
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y

# ENV
# Locale Japanese
# ENV LC_ALL=ja_JP.UTF-8
# tensorflowのログレベルをERRORのみに設定
ENV TF_CPP_MIN_LOG_LEVEL=2
# mecabrcが見つからないと怒られるので、環境変数MECABRCにパスを通す。(https://qiita.com/NLPingu/items/6f794635c4ac35889da6)
ENV MECABRC=/etc/mecabrc

# jupyter lab
RUN python3 -m pip install -U pip && \
    python3 -m pip install jupyterlab==3.3.4 && \
    python3 -m pip install jupyterlab-git==0.36.0 && \
    mkdir ~/.jupyter
# COPY ./jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
COPY ./jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py
RUN export NODE_OPTIONS=--max-old-space-size=4096
RUN jupyter serverextension enable --py jupyterlab && \
    jupyter labextension install --no-build jupyterlab-plotly && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install luxwidget && \
    # jupyter labextension install --no-build @jupyterlab/toc && \
    # jupyter labextension install --no-build jupyterlab-flake8 && \
    # jupyter labextension install --no-build jupyterlab-topbar-extension jupyterlab-system-monitor && \
    # jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager && \
    # jupyter labextension install --no-build @jupyterlab/debugger && \
    jupyter lab build

# RUN git clone https://github.com/K-PTL/noglobal-python
RUN git clone https://github.com/facebookresearch/fastText.git && \
    cd fastText && \
    python3 -m pip install --no-deps .

# TA-libのインストール
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
RUN tar -zxvf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    cp /usr/share/automake-1.16/config.guess . && \
    ./configure --prefix=/usr && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf ta-lib-0.4.0-src.tar.gz && rm -rf ta-lib
RUN python3 -m pip install TA-Lib

# M1 Mac用のTensorflowインストールコマンド
RUN python3 -m pip install tensorflow==2.6.0 -f https://tf.kmtea.eu/whl/stable.html && \
    python3 -m pip install keras==2.6.*


# COPY requirements.lock /tmp/requirements.lock
COPY requirements.txt /tmp/requirements.txt
# 依存関係を無視してインストールする場合
# RUN python3 -m pip install -U pip && \
#     python3 -m pip install --no-deps -r /tmp/requirements.txt && \
#     rm /tmp/requirements.txt && \
#     rm -rf /root/.cache
RUN python3 -m pip install -U pip
RUN python3 -m pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    rm -rf /root/.cache

# RUN python3 -m pip install cython

# takaggle
# 頻繁に更新するので個別でインストール
# RUN python3 -m  pip install -U git+https://github.com/takapy0210/takaggle@v1.0.30 && \
#     rm -rf /root/.cache

# Set up the program in the image
COPY working /opt/program/working
WORKDIR /opt/program/working
