# deepspam
to build:
git clone https://github.com/stivehu/deepspam.git
docker build -t deepspam .

to run:
docker run -d -p 1080:1080 --rm stivehu/deepspam
