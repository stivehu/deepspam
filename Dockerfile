FROM debian:stretch
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt full-upgrade
RUN apt -y install libmilter-dev python3-pip wget unzip
#RUN pip3 install tensorflow==1.5.0
RUN pip3 install tensorflow
#RUN pip3 install pymilter html2text keras==2.2.5
RUN pip3 install html2text keras==2.2.5 
#RUN wget https://github.com/sdgathman/pymilter/archive/master.zip && unzip master.zip && rm master.zip
RUN wget http://thot.banki.hu/deepspam/pymilter-master.zip && unzip pymilter-master.zip && rm pymilter-master.zip && \
    cd pymilter-master && python3 setup.py build  && python3 setup.py install && rm -rf pymilter-master
RUN mkdir -p /usr/local/ds/model 
COPY ds /usr/local/ds
RUN wget -nv http://thot.banki.hu/deepspam/model_v8_1/keras4_emb.py -O /usr/local/ds/keras4_emb.py && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_1/model.config  -O /usr/local/ds/model/model.config && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_1/model.weights -O /usr/local/ds/model/model.weights && \
    wget -nv http://thot.banki.hu/deepspam/model_v8_1/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap-py3
RUN chmod +x /usr/local/ds/deepspam.py
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam.py"]

