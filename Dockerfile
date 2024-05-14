FROM python:3.10

ENV TZ="Asia/Shanghai"

# 修复https源错误
RUN apt-get install apt-transport-https ca-certificates
# 备份源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
# 更改为TUNA源
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" >> /etc/apt/sources.list

# 安装必要组件
RUN apt update && \
    apt-get -y install libgl1-mesa-glx && \
    pip install poetry

# 安装依赖
WORKDIR /app
COPY ["pyproject.toml", "poetry.lock", "/app/"]
RUN poetry config virtualenvs.in-project true && \
    poetry install

# 添加源文件
COPY . /app

ENTRYPOINT ["poetry", "run", "python3", "main.py"]
