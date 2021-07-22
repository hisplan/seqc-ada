FROM hisplan/scri-notebook:0.0.2

LABEL maintainer="Jaeyoung Chun (chunj@mskcc.org)"

# python 3.9 included in the base image
# doubletdetection requires python >=3.6.1, <3.9
# fa requires python <3.9
RUN conda create -n workspace python=3.8 pip
RUN source activate workspace \
    && pip install scanpy[leiden]==1.7.2 papermill==2.3.3 PhenoGraph==1.5.7 \
    doubletdetection==3.0.0 fa2==0.3.5 seaborn==0.11.1

COPY ./notebooks/basic-analysis-v*.ipynb /opt/
COPY ./notebooks/to-adata.ipynb /opt/
COPY ./notebooks/doublet-detection.ipynb /opt/
COPY ./notebooks/get_optimal_k.py /opt/
COPY ./notebooks/RB_genes_human.txt /opt/
