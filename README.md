# RNA-Seq

---

# RNA-Seq Pipeline

- **Pipeline(Genome mapping or Trascriptome mapping)**

    ![RNA-Seq%20a76b3ceec3e14a9eb8745339f7acc4a5/Untitled.png](RNA-Seq%20a76b3ceec3e14a9eb8745339f7acc4a5/Untitled.png)

- **WMBIO의 pipeline**
    - Genome mapping은 **Tophat2 → Cufflinks**
    - Transcriptome mapping은 **Kallisto**
- **Reference**
    - Genome
        - .fa : UCSC GRCh38(hg38)
        - GTF : Gencode Release 37 (GRCh38.p13) - PRI
        - Transcriptome : Ensembl Homo_sapiens.GRCh38.cdna.all
    - **모든 Reference 파일은 NAS(192.168.0.90)에 저장되어 있음.**

        [](http://192.168.0.90:5000/sharing/uY0ZixfQA)

- **Script(.fastq.gz or .fq.gz Paired-end 기준)**

    ```bash
    git clone https://github.com/Jin0331/RNA_script.git
    ```

    1. [bam2fastq.sh](http://bam2fastq.sh) → BAM to Fastq conversion
    2. **wmbio_pipe.sh → Genome mapping & Transcriptome Pipeline run(trim_galore_pipe, tophat_pipe, cufflink_pipe, kallisto_pipe 포함)**

        ```bash
        # base dir 및 input dir 생성
        mkdir -p ~/temp/input_dir # 실행 후, temp 및 하위폴더로 input_dir 생성됨
        													# Pipeline에서 실행하고자 하는 Paired-end Fastq 파일을 넣어줄 것.
        													# ex) T84_R1.fastq.gz T84_R2.fastq.gz ...
        													# 모든 Fastq 파일은 [Name]_R[1 or 2].fastq.gz 형태로 이름을 바꿔줄 것
        													# *.gz 생성은 gzip [file]으로 진행

        cd ~/temp
        git clone https://github.com/Jin0331/RNA_script.git # script github

        RNA_script/wmbio_pipe.sh -r a -n jinoo -p Wmlswkdia1! -h 192.168.0.90 -b /home/wmbio/temp -i input_dir -t 30 -g fq

        ** Argument
        	-r : a - trim galore, kallisto, tophat->cufflink 모두 실행
        			 k - trim galore, kallisto 실행
        			 t - trim galore, tophat->cufflink 실행
        	-n : NAS ID
        	-p : NAS PASSWORD
        	-h : NAS ip
        	-b : base directory
        	-i : input directory
        	-x : index directory
        	-t : thread 개수
        	-g : fastq or fq

        ** 모든 결과 파일은 output_dir에 있음 ( QC, Kallisto, Tophat, Cufflink)
        ```

    3. sra_fastq_downloader.sh

        ```bash

        # sra_input.txt에 다운로드 받고자하는 SRR 넘버 기입하여 사용할 것. 
        # ex)
        # sra_input.txt>
        # SRR14082955
        # SRR2992201

        RNA_script/sra_fastq_downloader.sh /home/wmbio/temp/sra RNA_script/sra_input.tx
        ```
