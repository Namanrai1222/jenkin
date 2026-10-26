# Jenkins HTML Form Assessment

This repository contains a static [contact form](index.html) with Name, Email, Contact Number, and Submit fields. [Automated tests](tests/test_form.py) check the form structure. The [Jenkinsfile](Jenkinsfile) fetches this repository from GitHub, runs the HTML tests and the existing Java/Maven tests, publishes JUnit results, and archives the JAR.

## Build locally

Install JDK 25, Maven 3.9 or newer, and Python 3, then run:

```sh
mvn -B -ntp clean verify
java -jar target/java-maven-jenkins-demo-1.0.0-SNAPSHOT.jar
python3 -m unittest discover -s tests -v
```

The application prints `Hello, Jenkins!`. The JUnit tests verify the greeting behavior. The Python tests verify that the form contains labeled, required Name, Email, and Contact Number fields and a Submit button. Open `index.html` in a browser to view the form. Submission displays a demo message; no data is sent or stored.

## Run the form with Docker

With Docker Desktop running, build and start the static website:

```sh
docker build -t jenkins-html-form:1.0 .
docker run -d --name jenkins-html-form -p 127.0.0.1:8080:8080 jenkins-html-form:1.0
```

Open `http://127.0.0.1:8080/` in a browser. To check or stop the container:

```sh
docker ps --filter name=jenkins-html-form
curl -I http://127.0.0.1:8080/
docker stop jenkins-html-form
docker rm jenkins-html-form
```

The container serves the same demonstration form; submitting it does not send or store data.

## Connect Jenkins to GitHub

1. Install Jenkins LTS with JDK 25 and the Pipeline, Git, and JUnit plugins. Make JDK 25, Maven, and Python 3 available to the Jenkins process.
2. Create a Pipeline job. Choose Pipeline script from SCM, select Git, enter `https://github.com/Namanrai1222/jenkin.git`, set branch `*/main`, and set Script Path to `Jenkinsfile`.
3. Save and select **Build Now**. Open the build's **Console Output** and check for `BUILD SUCCESS`, `Ran 3 tests`, and `Finished: SUCCESS`. The **Test Result** page should show four passing Java tests.
4. The pipeline polls GitHub about every five minutes while Jenkins is running. This works for a local Jenkins server. For immediate builds, expose Jenkins securely and configure a GitHub webhook at `https://YOUR_JENKINS_HOST/github-webhook/`.

To verify that a GitHub push starts a build automatically, make and push a change from this checkout:

```sh
git add README.md
git commit -m "Document automatic Jenkins build verification"
git push jenkin main
```

Wait for the next SCM poll, then open `http://127.0.0.1:8095/job/html-form-pipeline/` and select the new build. Its cause should say **Started by an SCM change**. In **Console Output**, confirm the new commit was checked out, both test stages passed, and the log ends with `Finished: SUCCESS`. The local Jenkins server must be running for polling to occur.

Do not put GitHub credentials in this repository. Public repositories can be cloned without credentials. For a private repository, add a Jenkins credential and select it in the job Git SCM settings.
