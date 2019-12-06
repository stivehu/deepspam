FROM debian:stretch
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt full-upgrade
RUN apt -y install libmilter-dev python3-pip wget
RUN pip3 install tensorflow
RUN pip3 install pymilter html2text keras==2.2.5
RUN mkdir -p /usr/local/ds/model 
RUN wget http://thot.banki.hu/deepspam/milter-v0.3/deepspam.py -O /usr/local/ds/deepspam.py
RUN wget http://thot.banki.hu/deepspam/model_big_v3/model.config -O /usr/local/ds/model/model.config
RUN wget http://thot.banki.hu/deepspam/model_big_v3/model.weights -O /usr/local/ds/model/model.weights
RUN wget http://thot.banki.hu/deepspam/model_big_v3/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap
RUN wget http://thot.banki.hu/deepspam/milter-v0.3/milter.eml -O /usr/local/ds/milter.eml

RUN chmod +x /usr/local/ds/deepspam.py
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam.py"]

