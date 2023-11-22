## software

Install buttery-eel with Guppy 6.5.7:

```
 GUPPY_VERSION=6.5.7
 git clone https://github.com/Psy-Fer/buttery-eel -b multiproc
 cd buttery-eel
 git checkout 855fff2
 sed -i "s/6.3.8/${GUPPY_VERSION}/" requirements.txt
 python3.8 -m venv venv
 source venv/bin/activate
 pip3 install --upgrade pip
 pip3 install .

 #download and extract ont-guppy 6.5.7 

 # example command: 
 buttery-eel -g ont-guppy/bin/ -x cuda:all --port 5000 --use_tcp  --config dna_r10.4.1_e8.2_400bps_sup.cfg  -i PGXX22394_reads_chr22.blow5  -o PGXX22394_reads_chr22.fastq  
```


Install slow5-dorado 0.3.4:

```
wget -O slow5-dorado-0.3.4.tar.gz https://github.com/hiruna72/slow5-dorado/releases/download/v0.3.4/slow5-dorado-v0.3.4-x86_64-linux.tar.gz
tar xf slow5-dorado-0.3.4.tar.gz
cd slow5-dorado
mkdir models
cd models
../bin/slow5-dorado download --model all

```


Install minimap 2.26

```
wget https://github.com/lh3/minimap2/releases/download/v2.26/minimap2-2.26_x64-linux.tar.bz2
tar xf minimap2-2.26_x64-linux.tar.bz2
```

Install modkit 0.1.13

```
https://github.com/nanoporetech/modkit/releases/download/v0.1.13/modkit_v0.1.13_centos7_x86_64.tar.gz
tar xf modkit_v0.1.13_centos7_x86_64.tar.gz
```

## references

- For DNA: hg38noAlt.fa or hg38noAlt.idx

- For RNA: [gencode.v40.transcripts.fa](https://www.dropbox.com/scl/fi/cigvodv4bfoiau7hnctrs/gencode.v40.transcripts.fa?rlkey=9agvj4693d2wifyhenicksuyd&dl=1)


## Methylation truthsets

For HG001: [bisulfite.ENCFF835NTC.bed](https://www.dropbox.com/scl/fi/mdhggu3sazhnyp7mppn15/bisulfite.ENCFF835NTC.bed.gz?rlkey=6o6obxg3bgr3wkzynasyem4n1&dl=1)

For HG002: [hg2_chr22_bi.tsv](https://www.dropbox.com/scl/fi/prpohd7mqtt6pg1n2umf3/hg2_chr22_bi.tsv?rlkey=sfvl3q5pta9s4fn6fz29n3iqj&dl=1)

## Datasets

HG002 chr22 R10.4.1 5KHz: [PGXXXX230339_reads_chr22.blow5](https://www.dropbox.com/scl/fi/d1acc4bes8j7smtzbuioj/PGXXXX230339_reads_chr22.blow5?rlkey=96lc1mhbyklz62quhacp7wjd8&dl=1)
- guppy: dna_r10.4.1_e8.2_400bps_5khz_sup.cfg, dna_r10.4.1_e8.2_400bps_5khz_hac_prom.cfg
- dorado: dna_r10.4.1_e8.2_400bps_sup@v4.2.0, dna_r10.4.1_e8.2_400bps_hac@v4.2.0
- guppy remora: dna_r10.4.1_e8.2_400bps_5khz_modbases_5mc_cg_sup_prom.cfg, dna_r10.4.1_e8.2_400bps_5khz_modbases_5mc_cg_hac_prom.cfg
- dorado remora: same as above with flag: --modified-bases 5mCG_5hmCG 

HG002 chr22 R10.4.1 4KHz: [PGXX22394_reads_chr22.blow5](https://www.dropbox.com/scl/fi/f0iqkomu1i5v692fgqcrh/PRPN119035_reads.blow5?rlkey=zbl4bfthvpkqs3bo8pfnw30cs&dl=1)
- guppy: dna_r10.4.1_e8.2_400bps_sup.cfg, dna_r10.4.1_e8.2_400bps_hac_prom.cfg
- guppy remora: dna_r10.4.1_e8.2_400bps_modbases_5mc_cg_sup_prom.cfg, dna_r10.4.1_e8.2_400bps_modbases_5mc_cg_hac_prom.cfg
- dorado: dna_r10.4.1_e8.2_400bps_sup@v4.1.0, dna_r10.4.1_e8.2_400bps_hac@v4.1.0
- dorado remora: same as above with flag: --modified-bases 5mCG_5hmCG 

HG001 chr22 R9.4.1 4KHz: [na12878_prom_merged_r9.4.1_chr22.blow5](https://www.dropbox.com/scl/fi/9a6oiiad5vzacm13udhi5/na12878_prom_merged_r9.4.1_chr22.blow5?rlkey=yqpppfxj3bch3rd8cq1dep65q&dl=1)
- guppy: dna_r9.4.1_450bps_sup_prom.cfg, dna_r9.4.1_450bps_hac_prom.cfg
- guppy remora: dna_r9.4.1_450bps_modbases_5mc_cg_sup_prom.cfg, dna_r9.4.1_450bps_modbases_5mc_cg_hac_prom.cfg
- dorado: dna_r9.4.1_e8_sup@v3.3, dna_r9.4.1_e8_hac@v3.3
- dorado remora: same as above with flag: --modified-bases 5mCG_5hmCG 

UHR RNA R9.4.1: [PRPN119035_reads.blow5](https://www.dropbox.com/scl/fi/f0iqkomu1i5v692fgqcrh/PRPN119035_reads.blow5?rlkey=zbl4bfthvpkqs3bo8pfnw30cs&dl=1)
- guppy: rna_r9.4.1_70bps_hac_prom.cfg
- dorado: rna002_70bps_hac@v3
- minimap2: minimap2 -ax splice -uf -k14 --secondary=no gencode.v40.transcripts.fa reads.fastq



## per read identity 

```
samtools fqidx a.fastq
samtools fqidx b.fastq
cat a.fastq.fai | cut -f 1 > a_ridlist.txt
while read rid;
do
    echo -n -e $rid"\t";
    samtools fqidx a.fastq $rid -n 100000000 > a_tmp.fastq;
    samtools fqidx b.fastq $rid -n 100000000 > b_tmp.fastq;
    minimap2 -cx map-ont --secondary=no a_tmp.fastq b_tmp.fastq -t1 | awk '{print $10/$11}' | head -1 | tr -d '\n';
    echo ;
done < a_ridlist.txt > perreadidentity.txt

```
