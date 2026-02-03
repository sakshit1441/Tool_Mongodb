# **Ansible Assignment 3**

## **Infrastructure Setup & Spring3Hibernate Application Deployment (Playbook Only)**

---

## **Objective**

The objective of this assignment is to **automate complete infrastructure setup and deploy a Java-based web application on AWS EC2 using a single Ansible playbook**.

The solution uses **only Ansible YAML (no bash scripts)** to:

* Install required software
* Build a Java WAR file
* Deploy the application on Apache Tomcat
* Verify successful deployment

---

## **Application Details**

* **Application Name**: Spring3HibernateApp
* **Source Repository**: [https://github.com/opstree/spring3hibernate](https://github.com/opstree/spring3hibernate)
* **Application Type**: Java Web Application (WAR)
* **Java Version**: OpenJDK 11
* **Build Tool**: Maven
* **Web Server**: Apache Tomcat 7
* **Database**: MySQL

---

## **Environment Details**

* **Cloud Provider**: AWS EC2
* **Instance OS**: Ubuntu
* **Public IP**: `13.1.113.183`
* **Tomcat Installation Path**:

  ```
  /opt/tomcat/apache-tomcat-7.0.108
  ```

---

## **Project Structure**

```
Assignment3/
├── ansible.cfg
├── inventory.ini
└── site.yml
```

---

## **What the Playbook Does**

1. Installs **OpenJDK 11**
2. Installs **Maven**
3. Installs and starts **MySQL**
4. Downloads and installs **Apache Tomcat**
5. Clones Spring3Hibernate source code
6. Builds WAR file using Maven
7. Deploys WAR to Tomcat webapps directory
8. Starts / restarts Tomcat
9. Ensures idempotent execution

---

## **How to Run the Playbook**

### Step 1: Go to Assignment Directory

```bash
cd ~/Ansible_33/Assignment3
```

### Step 2: Run the Playbook

```bash
ansible-playbook site.yml
```

---

## **Verification Steps (Success Check)**

### 1. Verify Java Installation

```bash
java -version
```

Expected:

```
openjdk version "11"
```

---

### 2. Verify Maven Installation

```bash
mvn -version
```

Expected:

```
Apache Maven 3.x.x
Java version: 11
```

---

### 3. Verify MySQL Service

```bash
systemctl status mysql
```

Expected:

```
Active: active (running)
```

---

### 4. Verify WAR File Creation

```bash
ls /opt/spring3hibernate/target
```

Expected:

```
Spring3HibernateApp.war
```

---

### 5. Verify WAR Deployment to Tomcat

(**Note: `/opt` is a root-owned directory, so `sudo` is required**)

```bash
sudo ls /opt/tomcat/apache-tomcat-7.0.108/webapps/
```

Expected:

```
Spring3HibernateApp.war
Spring3HibernateApp/
```

---

### 6. Verify Tomcat Is Running

```bash
sudo ps -ef | grep tomcat
```

Expected:

* Java process running for Tomcat

---

### 7. Verify Application in Browser (Most Important)

Open in browser:

```
http://65.1.113.183:8080/Spring3HibernateApp
```

Expected:

* Spring3Hibernate application page loads successfully

---

## **Screenshots**


1. Successful Ansible playbook execution (PLAY RECAP)
![alt text](3.1(1).png)

2. Java version output

3. Maven version output
<img width="845" height="144" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/e4caec71-9e7e-4a83-83c0-65d8257b1289" />

4. MySQL running status
<img width="1048" height="340" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/3d51afad-9d1a-4ec0-8a18-91289a4a91e4" />

5. WAR file created
<img width="1403" height="96" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/9043700f-c293-4d7a-aae8-8d3af44dbb91" />
<img width="718" height="117" alt="Pasted image (6)" src="https://github.com/user-attachments/assets/2199e835-aa20-4e21-baa4-fc179f6bb4dd" />
<img width="1303" height="55" alt="Pasted image (7)" src="https://github.com/user-attachments/assets/e207500e-ca74-42e6-8f9b-85705527f573" />

6. WAR deployed to Tomcat (`sudo ls`)
<img width="909" height="55" alt="Pasted image (8)" src="https://github.com/user-attachments/assets/c5fadb32-c48d-47a5-a413-1f322a3639d8" />

7. Tomcat running process
<img width="1850" height="135" alt="Pasted image (9)" src="https://github.com/user-attachments/assets/c6454a6f-682a-4d49-a2a8-07c282792ee4" />
<img width="618" height="49" alt="Pasted image (10)" src="https://github.com/user-attachments/assets/b285c080-03eb-45f1-b449-dff90fc2b425" />

8. Application opened in browser
<img width="717" height="537" alt="Pasted image (11)" src="https://github.com/user-attachments/assets/3c0f67f3-7783-4532-9d01-7680cce9dfb0" />

```
screenshots/
├── 01-playbook-success.png
├── 02-java-version.png
├── 03-maven-version.png
├── 04-mysql-running.png
├── 05-war-created.png
├── 06-war-deployed.png
├── 07-tomcat-running.png
└── 08-application-browser.png
```

---

## **Idempotency Check**

The playbook can be run multiple times safely.

```bash
ansible-playbook site.yml
```

* Already installed components are skipped
* No failures occur
* Confirms idempotent behavior

---

## **Important Notes**

* Entire automation is done using Ansible YAML
* Root permissions are required only for system paths under `/opt`
* This approach follows Ansible best practices

---

## **Conclusion**

This assignment demonstrates:

* Infrastructure automation using Ansible
* Java application build and deployment
* Playbook-only approach (no scripts)
* Successful deployment on AWS EC2
* Clean, idempotent configuration management

The Spring3Hibernate application was deployed and verified successfully.

---
