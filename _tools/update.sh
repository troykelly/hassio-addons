#!/usr/bin/env bash
BRANCH=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
rm -Rf ./update-hak5c2 ./update-letslexicon ./update-unimus && \
  git clone --depth=1 --branch=${BRANCH} https://github.com/troykelly/hassio-addons-hak5c2.git update-hak5c2 && rm -rf ./update-hak5c2/.git && \
  git clone --depth=1 --branch=${BRANCH} https://github.com/troykelly/hassio-addons-letsencrypt-lexicon.git update-letslexicon && rm -rf ./update-letslexicon/.git && \
  git clone --depth=1 --branch=${BRANCH} https://github.com/troykelly/hassio-addon-unimus.git update-unimus && rm -rf ./update-unimus/.git && \
  rm -Rf ./hak5c2 ./letslexicon ./unimus && \
  mv ./update-hak5c2 ./hak5c2 && \
  mv ./update-letslexicon ./letslexicon && \
  mv ./update-unimus ./unimus
rm -Rf ./update-hak5c2 ./update-letslexicon ./update-unimus
