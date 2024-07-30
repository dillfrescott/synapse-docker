FROM ubuntu:24.04

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y python3 python3-pip git rustup postgresql-server-dev-all

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
	
RUN rustup default stable
	
RUN git clone https://github.com/element-hq/synapse

WORKDIR synapse

# Version 1.111.1
RUN git checkout e4868f8a1e0e4e5898facf8819596fda5c8e8721

RUN pip install psycopg2 poetry setuptools-rust==1.8.1 --break-system-packages

RUN python3 -m build --wheel --no-isolation

RUN pip install dist/*.whl --break-system-packages

WORKDIR /data

RUN rm -rf /synapse

ENTRYPOINT ["/bin/bash", "-c", "synctl start --no-daemonize"]
