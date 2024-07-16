FROM ubuntu:24.04

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y python3 python3-pip git rustup postgresql-server-dev-all wget

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
	
RUN rustup default stable
	
RUN git clone https://github.com/element-hq/synapse

WORKDIR synapse

# Version 1.110.0
RUN git checkout 75b788f49f005bbc70b459d30913f1f7abf847cb

RUN pip install psycopg2 boto3 poetry setuptools-rust==1.8.1 --break-system-packages

RUN python3 -m build --wheel --no-isolation

RUN pip install dist/*.whl --break-system-packages

WORKDIR /

RUN rm -rf /synapse

RUN mkdir /python_path

WORKDIR /python_path

RUN wget https://raw.githubusercontent.com/matrix-org/synapse-s3-storage-provider/main/s3_storage_provider.py

WORKDIR /data

ENV PYTHONPATH=/python_path

ENTRYPOINT ["/bin/bash", "-c", "synctl start --no-daemonize"]
