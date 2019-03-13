### Optimized Tensorflow builds for CPU

These images have been built for with 

| Version |       SSE        |       AVX2         |    AVX512          |     MKL-DNN        |   PY |
|----------|-----------------|--------------------|--------------------|--------------------|------|
| 1.13.1 |:heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |3.7.1 |


- Inludes Dockerfile of the build environment

#### Steps to build locally
- Clone the repo, change dir to `bazel-build-tf`
- Do a `docker build`:

    ```bash
        docker build -t tf-build .
    ```

- Once build finishes, run an instance of the image in detached mode:

    ```bash
        docker run -dt tf-build
    ```
- Copy the wheels from the docker image using:

    ```bash
        docker cp  <container id>:/tensorflow_builds .
    ```
       ```
#### Wheels can be downloaded from: 
- SSE - https://www.dropbox.com/s/ew6iwc8tssu39jc/tensorflow-1.13.1-cp37-cp37m-linux_x86_64.whl?dl=0
- SSE + AVX2 - https://www.dropbox.com/s/2rqjn20up6nyxn3/tensorflow-1.13.1-cp37-cp37m-linux_x86_64.whl?dl=0
- SSE + AVX2 + AVX512 - https://www.dropbox.com/s/dnph12qf3k8al33/tensorflow-1.13.1-cp37-cp37m-linux_x86_64.whl?dl=0



