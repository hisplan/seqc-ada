FROM hisplan/scri-notebook:0.0.2

LABEL maintainer="Jaeyoung Chun (chunj@mskcc.org)"

# python 3.9 included
# doubletdetection requires python >=3.6.1, <3.9
RUN conda create -n doubletdetection python=3.8 pip
RUN source activate doubletdetection \
    && pip install scanpy[leiden]==1.7.2 papermill==2.3.3 PhenoGraph==1.5.7 doubletdetection==3.0.0

COPY ./notebooks/basic-analysis.ipynb /opt/
COPY ./notebooks/to-adata.ipynb /opt/
COPY ./notebooks/doublet-detection.ipynb /opt/
