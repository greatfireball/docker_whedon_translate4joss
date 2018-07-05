ARG osversion=xenial
FROM ubuntu:${osversion}

ENV WHEDON_DIR=/opt/whedon

RUN apt update && \
    apt install --yes --no-install-recommends \
       pandoc \
       git \
       pandoc-citeproc \
       texlive \
       texlive-latex-extra \
       texlive-bibtex-extra \
       biber \
       texlive-fonts-recommended \
       lmodern texlive-xetex \
       wget && \
    wget -O /tmp/pandoc.deb https://github.com/jgm/pandoc/releases/download/2.1.1/pandoc-2.1.1-1-amd64.deb && \
    dpkg -i /tmp/pandoc.deb && \
    git clone https://github.com/openjournals/whedon.git "${WHEDON_DIR}"

VOLUME /data
WORKDIR /data

ENTRYPOINT pandoc -o paper.pdf -V geometry:margin=1in --filter pandoc-citeproc paper.md --template "${WHEDON_DIR}"/resources/latex.template --variable formatted_doi=pending -V joss_logo_path="${WHEDON_DIR}"/resources/joss-logo.png --pdf-engine=xelatex

CMD "--variable=repository:https://link-to-repo --variable=archive_doi:https://archive-doi"
