FROM ubuntu:24.04 AS builder

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y python3 python3-pip git rustup postgresql-server-dev-all wget
	
RUN rustup default stable
	
RUN git clone https://github.com/element-hq/synapse /synapse

WORKDIR /synapse

# Version 1.138.0
RUN git checkout fcffd2e897aaef1583bcb1f93893f254330ec81c

RUN pip install psycopg2 boto3 poetry poetry-core==1.9.0 setuptools-rust==1.8.1 --break-system-packages

RUN python3 -m build --wheel --no-isolation

FROM ubuntu:24.04 AS main

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y python3 python3-pip postgresql-server-dev-all wget

RUN pip install psycopg2 boto3 authlib --break-system-packages

COPY --from=builder /synapse/dist /dist

RUN pip install /dist/*.whl --break-system-packages

WORKDIR /

RUN mkdir /python_path

WORKDIR /python_path

RUN wget https://raw.githubusercontent.com/matrix-org/synapse-s3-storage-provider/main/s3_storage_provider.py

WORKDIR /data

ENV PYTHONPATH=/python_path

ENTRYPOINT ["/bin/bash", "-c", "synctl start --no-daemonize"]
