FROM debian:stretch
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt full-upgrade
RUN apt -y install libmilter-dev python3-pip wget unzip
#RUN pip3 install tensorflow==1.5.0
RUN pip3 install tensorflow
#RUN pip3 install pymilter html2text keras==2.2.5
RUN pip3 install html2text keras==2.2.5 
RUN wget https://github.com/sdgathman/pymilter/archive/master.zip && unzip master.zip && rm master.zip
RUN cd pymilter-master && python3 setup.py build  && python3 setup.py install
RUN rm -rf pymilter-master
RUN mkdir -p /usr/local/ds/model 
COPY ds /usr/local/ds
RUN wget -nv http://thot.banki.hu/deepspam/model_v7_6-jo/keras4_emb.py -O /usr/local/ds/keras4_emb.py
RUN wget -nv http://thot.banki.hu/deepspam/model_v7_6-jo/model.config  -O /usr/local/ds/model/model.config
RUN wget -nv http://thot.banki.hu/deepspam/model_v7_6-jo/model.weights -O /usr/local/ds/model/model.weights
RUN wget -nv http://thot.banki.hu/deepspam/model_v7_6-jo/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap-py3
RUN chmod +x /usr/local/ds/deepspam.py
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam.py"]

