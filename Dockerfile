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
RUN wget http://thot.banki.hu/deepspam/model_big_v5/keras1_emb.py -O /usr/local/ds/keras1_emb.py
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.config  -O /usr/local/ds/model/model.config
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.weights -O /usr/local/ds/model/model.weights
#RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.wordmap-py3 -O /usr/local/ds/model/model.wordmap
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/deepspam.py -O /usr/local/ds/deepspam.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/ds_model.py -O /usr/local/ds/ds_model.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/eml2token.py -O/usr/local/ds/eml2token.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/eml2txt.py -O /usr/local/ds/eml2txt.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/htmlentitydefs.py -O /usr/local/ds/htmlentitydefs.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/maildedup2.py -O /usr/local/ds/maildedup2.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/parsehdr.py -O /usr/local/ds/parsehdr.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/tester.py -O /usr/local/ds/tester.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/txt2tok.py -O /usr/local/ds/txt2tok.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/txt2tok_test.py -O /usr/local/ds/txt2tok_test.py
RUN wget http://thot.banki.hu/deepspam/milter-v0.6/unicodes.map -O /usr/local/ds/unicodes.map
RUN wget http://thot.banki.hu/deepspam/milter-v0.3/milter.eml -O /usr/local/ds/milter.eml
RUN wget http://thot.banki.hu/deepspam/model_big_v5/model.wordmap-py2 -O /usr/local/ds/model/model.wordmap-py2
RUN chmod +x /usr/local/ds/deepspam.py
EXPOSE 1080
WORKDIR /usr/local/ds/
ENTRYPOINT ["/usr/bin/python3","/usr/local/ds/deepspam.py"]

