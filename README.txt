Deepspam-milter docker image
TO rebuild:
git clone 
docker build -t stivehu/deepspam .

Chgangelog v0.2-teszt:
================

Felraktam a v0.8 verziot, a fo valtozas/ujdonsag az attachmentek parsolasa (docx, rtf, pdf, winmail.dat), illetve a model is bovult egy adag ujfajta spam levellel:
http://thot.banki.hu/deepspam/milter-v0.8/
http://thot.banki.hu/deepspam/model_v8_2_teszt/


https://hup.hu/comment/2515770#comment-2515770

Chgangelog v0.8.1:
================
uj model frissitve a majusi mintakkal (+3000 level):

http://thot.banki.hu/deepspam/model_v8_1/


Chgangelog v0.8-teszt:
================

Tegnap talaltam 2 problemat/hibat:

1. a refactoring soran bekerult v0.6 kornyeken egy 'minlen' parameter a tokenizaloba, es ennek a szurohoz nem jo a default erteke -> emiatt a 4 betunel rovidebb szavakat nem szamolta. altalaban nem okoz gondot, mert azok foleg kotoszavak, nevelok, de nagyon rovid leveleknel, mint  pl az outlook tesztlevele az is szamit. ezt kell atirni 'minlen=1'-re:

eml2token.py:  def tokenize(s,vocab,minlen=4):

2. decemberben megfigyeltem, hogy (majdnem) ugyanarra a tartalmu levelre is eltero eredmenyt adhat a szuro, es csak a megszolitas/nev tert el a levelek tartalmaban. valoszinuleg megtanulta, hogy bizonyos nevek sokkal jellemzobbek a spam levelekre :)  (bizonyos nevu userek sok spamet kapnak, es igy a tanitashoz hasznalt datasetben felulreprezentaltak)

ezert akkor beraktam egy nev listat, az angol es magyar kereszt- es vezeteknevekkel, hogy ezeket ne vegye figyelembe, de mint most kiderult, olyan "nevek" is vannak a listaban, mint 'bank' vagy pl. 'minden', foleg az angolok neveznek el embereket gyakorlatilag barmirol, igy az a lista tele van baromsagokkal, de a magyarban is van pl. 'kis' meg 'nagy' ugye... ezt most egyelore kivettem, majd at kell nezni kezzel a listat es a csak nevkent, mas jelentessel nem birokat meghagyni, de ez rohadt sok melo lesz...

http://thot.banki.hu/deepspam/w2v-models/nevek_freq.txt

ezekkel korrigalva, valamint az aprilisi mintakkal kiegeszitve generaltam egy uj modelt, lehet tesztelni:

http://thot.banki.hu/deepspam/model_v8-teszt/

a 193.224.38.187:1080 milteren mar ez megy, minlen=


Chgangelog v0.7:
================

Uj release:   http://thot.banki.hu/deepspam/milter-v0.7/

- ds_model-bol keszult egy queue alapu verzio, ami 1 thread-ben futtatja a keras+tensorflow-t, a deepspam.py mar ezt hasznalja.

- es egy uj, ppymilter-re epulo verzio (deepspam3.py), ami teljesen 1 szalon fut, semmi multithreading, es nem zabalja (annyira) a memoriat :)

Uj model:     http://thot.banki.hu/deepspam/model_v7_6-jo/

- A v7 ota kivettem az LSTM reteget, igazabol nem hozott annyi pluszt, amennyi eroforrast eszik, es neha furcsan is viselkedett. helyette tobb Convolution layer lett.
- 2020.marcius vegeig beerkezett es ellenorzott spam/ham mintakkal tanitva:

    41006 mail.neg
    58252 mail.pos
    99258 total

- html parser atirva, jobban kezeli az extrem eseteket
- kodlap kezeles javitasok, pl. hibas utf8...
- tokenizalas modositva, anonimizalja a cimeket (email/url), szamokat
  emiatt javasolt az uj model (v3) hasznalata, mert az mar az uj parserrel keszult!
- mar nincs python 2.x support, de ha van ra igeny megnezem majd, viszont foleg a kodlap kezeles tok maskepp megy 3.x alatt...

INSTALL
=======
A hasznalathoz eleg csak a milter modult (deepspam.py) futtatni a mailserveren.
A parameterek egyelore bele vannak drotozva, ami lenyeges az a socket, by default a 1080-as TCP porton figyel.
Indulaskor betolti es elemzi a milter.eml filet ami egy teszt spam level, ha ez sikerul utana indul csak a milter resz.
(ha csak tesztelgetni akarod, akkor a miltert ki lehet kommentezni es a milter.eml-t kell kicserelni a teszt levelre)

DEPENDENCY:
- Python 3.x  (3.5, 3.6 tesztelve)
- pymilter    (python 3.x-hez pip-el nekem nem fordul, de kezzel a forrasbol a milter.patch alkalmazasa utan igen)
- numpy
- html2text
- h5py   (3-as pythonhoz lehet pickle formatumu modelt is menteni, akkor ez nem szukseges)
- Keras  (pip3 install keras) - a v2.3.0-val nem mukodik, mert van benne egy multi threading bug!
- Tensorflow (elvileg Theanoval is mukodhet, de nem teszteltem) - ha regi a CPU (nincs AVX/AVX2) akkor max 1.5-os verzio hasznalhato!
- GPU _nem_ szukseges hozza (kb 6-8ms 1 level ellenorzese CPU-val), de ha megis van, akkor CUDA8 + CuDNN + tensorflow-gpu kell a hasznalatahoz 
  (de ha sajat modelt akarsz gyartani (learn/*) akkor viszont erosen ajanlott egy izmosabb GPU nagyon sok memoriaval! a 1080ti-vel is 20-60 perc egy menet...)


Postfix konfiguracio:
  smtpd_milters = inet:127.0.0.1:1080
  milter_default_action = accept
(a 2. sor azert kell, hogy hiba eseten ne dobalja vissza a leveleket)

Spamassassin konfiguracio:  (pl. /var/lib/spamassassin/3.004000/deepspam.cf fileba, de mehet az user_prefs-be is)

header   DEEPSPAM_HAM       X-deepspam =~ /^ham/i
describe DEEPSPAM_HAM       DeepSpam probability<2%
score    DEEPSPAM_HAM       -3

header   DEEPSPAM_MHAM       X-deepspam =~ /^maybeham/i
describe DEEPSPAM_MHAM       DeepSpam probability<10%
score    DEEPSPAM_MHAM       -2

header   DEEPSPAM_M2HAM       X-deepspam =~ /^20ham/i
describe DEEPSPAM_M2HAM       DeepSpam probability<20%
score    DEEPSPAM_M2HAM       -1

header   DEEPSPAM_SPAM       X-deepspam =~ /^spam/i
describe DEEPSPAM_SPAM       DeepSpam probability>98%
score    DEEPSPAM_SPAM       6

header   DEEPSPAM_MSPAM       X-deepspam =~ /^maybespam/i
describe DEEPSPAM_MSPAM       DeepSpam probability>90%
score    DEEPSPAM_MSPAM       4

header   DEEPSPAM_M2SPAM       X-deepspam =~ /^80spam/i
describe DEEPSPAM_M2SPAM       DeepSpam probability>80%
score    DEEPSPAM_M2SPAM       2

http://thot.banki.hu/deepspam/milter-v0.3/
http://thot.banki.hu/deepspam/model_big_v3/