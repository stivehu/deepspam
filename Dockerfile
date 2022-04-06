FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt -y full-upgrade && \
    apt -y install libmilter-dev python3-pip wget \
    unzip python-pdfminer apt-utils pkg-config libhdf5-103 libhdf5-cpp-103 libhdf5-dev libblas3 liblapack3 liblapack-dev \
    libblas-dev libatlas-base-dev gfortran python3-h5py && \
    apt clean autoclean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN pip3 install --no-cache-dir tensorflow
RUN pip3 install --no-cache-dir html2text keras==2.2.5 
RUN mkdir -p /usr/local/ds/model 
COPY ds /usr/local/ds
RUN wget -nv http://thot.banki.hu/deepspam/model-v90.tgz -O /tmp/model-v90.tgz && \
    cd /usr/local/ds && tar xvzpf /tmp/model-v90.tgz && rm -rf /tmp/model-v90.tgz
RUN chmod +x /usr/local/ds/deepspam.py
RUN mv /usr/local/ds/model-v90/* /usr/local/ds/model && rm -rf /usr/local/ds/model-v90/
RUN wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/keras4_emb.py -O /usr/local/ds/keras4_emb.py && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/model.config  -O /usr/local/ds/model/model.config && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/model.weights -O /usr/local/ds/model/model.weights && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/dataset.txt -O /usr/local/ds/model/dataset.txt && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap-py3 && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_2_teszt/model.wordmap-py2 -O /usr/local/ds/model/model.wordmap-py2
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam3.py"]

