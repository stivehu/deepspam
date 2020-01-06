FROM debian:stretch
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt full-upgrade
RUN apt -y install libmilter-dev python3-pip wget
#RUN pip3 install tensorflow==1.5.0
RUN pip3 install tensorflow
RUN pip3 install pymilter html2text keras==2.2.5
RUN mkdir -p /usr/local/ds/model 
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/deepspam.py -O /usr/local/ds/deepspam.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/ds_model.py -O /usr/local/ds/ds_model.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/eml2token.py -O/usr/local/ds/eml2token.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/eml2txt.py -O /usr/local/ds/eml2txt.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/htmlentitydefs.py -O /usr/local/ds/htmlentitydefs.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/maildedup2.py -O /usr/local/ds/maildedup2.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/tester.py -O /usr/local/ds/tester.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.5-dev/txt2tok.py -O /usr/local/ds/txt2tok.py
RUN wget http://thot.banki.hu/deepspam/model_big_v5/keras1_emb.py -O /usr/local/ds/keras1_emb.py
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.config  -O /usr/local/ds/model/model.config
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.weights -O /usr/local/ds/model/model.weights
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap
#RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.wordmap-py2 -O /usr/local/ds/model/model.wordmap-py2
RUN wget http://thot.banki.hu/deepspam/milter-v0.3/milter.eml -O /usr/local/ds/milter.eml

RUN chmod +x /usr/local/ds/deepspam.py
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam.py"]

