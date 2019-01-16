# Exam in PGR301 - DevOps i skyen

[Exam task](docs/examtask.md)

## Description
This project contains two projects: Infrastructure and Application. <br/>
The Infrastructure is using Terraform and Concourse to apply, build and control the different parts of the application-infrastructure. Here I utilize features like Github repositories, Heroku pipeline with Heroku Container Registry and Docker to publish the application. <br/>
For metrics and surveillance of the application I use the Hosted Graphite plugin for Heroku and StatusCake, all of these are created and managed by using Terraform providers.

The application is pretty simple, it is a minimum viable product API build with Java, Maven and Spring. The only modification i've done to the repository we got handed with the task is adding metrics to monitor the behavior of the API.

## Repos
[Repository for Application](https://github.com/MiniMarker/DevOps_App_Exam)<br/> 
[Repository for Infrastructure](https://github.com/MiniMarker/DevOps_Infra_Exam)<br/>

## Tasks done
1. Caching of Maven repositories
2. Basic setup (10p)
3. Docker (20p)
4. Metrics (20p)

Total = 50p

## How to run the project
1. Clone/fork repos
2. I assume that you have **Docker** and **Docker Compose** installed on your computer. Next you need to get the Concourse docker-image. A guide on how to install and run Concourse can be found here:
	- [Tutorial guide on Concourse](https://concoursetutorial.com/)<br/>
3. The application should be fine as is
4. The infrastructure is all filled with FIXME marks, these spots need to be filled with new credentials. The following files that needs editing is:
	- `/credentials_template.yml` (wait with `hosted_graphite_apikey_xxxxx` until task 8)
	- `/terraform/provider_heroku.tf`
	- `/terraform/statuscake.tf`
	- `/concourse/pipeline.yml`
5. Rename `/credentials_template.yml` to `/credentials.yml`
6. Push changes in Infra to GitHub
7. Now you need to build the pipeline by using the following command in the terminal.
	- `fly -t <target> sp -p <pipeline_name> -c concourse/pipeline.yml -l credentials.yml`
8. In `localhost:8080` **run the infra and build once.**
	- As the exam task states there is a "chicken and the egg"-issue when declaring and implementing Hosted Graphite. This results in that the host and api keys aren't known until the **infra** task in concourse has ran and build the Heroku pipeline once.
9. Now go into the Hosted Graphite plugin in every app in pipeline created at Heroku, get Host og ApiKey from these pages and put these values into every `hosted_graphite_apikey_xxxxxxx` in `/credentials.yml`
10. Now you need to build the pipeline by using the following command in the terminal.
	- `fly -t <target> sp -p <pipeline_name> -c concourse/pipeline.yml -l credentials.yml`
11. Run the run the infra and build manually from `localhost:8080`
12. Now you should be able to go to `https://devops-exam-app-ci.herokuapp.com/` and access the Application.

**NB:** If you change the name of the `app_prfix` variable in point **3** `/terraform/variables.tf` you also have to update the app names in all the `heroku config:set` scripts at the bottom of the file located at `/concourse/envorment_vars.yml` to follow this format `-a <app_prefix>-app-ci`. The Application-url will also change accordingly to the naming.


## Known issues
1. Sometimes Heroku cant bind the port to the docker images. This results in the following error code in the Heroku CLI logs:
	- `Web process failed to bind to $PORT within 60 seconds of launch` <br/>
**How to fix this error**: run the build process one more time
2. Since there are **impossible to promote** applications that are uploaded to Heroku pipeline using Heroku Container Registry the stage and production apps in the pipeline will be empty and without any functionality. However, since the task stated that we should focus on **Enviorment parity** I have implemented the same Hosted Graphite metrics and PostgreSQL database on all stages of the pipeline.
3. Since the free trial on Hosted Graphite limits ut to **max 5 metrics**, and if we go over that limit the metrics that we are implementing are stopping to receive data from the app. Example:
	- I implement a meter for WelcomePage visitors. It uses 5/10 available spots. everything works fine and Hosted Graphite is receiving data points from the app.
	- Next I implement a load time Timer for the homepage. It uses 10/10 available spots so im on a total of 15/10 metrics. 
	- Now Hosted Graphite blocks all incoming data, even the Meter that were working before i implemented the Timer is stopped. <br/><br/>
	- I've added different meter types (as the task requires) anyhow but they are not working because of this problem. I'm trying to block unnecessary ones by using `.disabledMetricAttributes(excludeSet)` but I still end over the max limit of metrics. 
