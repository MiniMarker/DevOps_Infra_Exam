# DevOps_Exam_Infra

This repo consists of infrastructure code for setup, building and deploying a REST-Api made with Java

## Tasks done:
1. Basic pipeline setup
2. Caching
    - Notes: For this task i needed to change the task.sh file to make terraform save dependency repos in the docker image.
    For this i needed to make a mandatory folders (.m2/repository) in the root directory. 
    After that had been done I created a file (settings.xml) and inserted the following xml code into it:
    ```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              https://maven.apache.org/xsd/settings-1.0.0.xsd">
          <localRepository>${M2_LOCAL_REPO}/repository</localRepository>
    </settings>
    ```
    - I also had to tell the task where to look for cache by adding
    ```yaml
    caches:
      - path: .m2/
    ```
    
3. Deployment with Docker
    - Notes: I started this task by replacing the existing 