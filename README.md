Here’s a **perfectly formatted and Markdown-styled version** of your entire setup sheet, ready to paste directly into your `README.md` file — cleanly aligned and easy to read 👇

---

# 🚀 DevOps Setup Guide

## 🧩 Jenkins Installation (Ubuntu 24.04)

```bash
# 1. Update system packages
sudo apt update -y

# 2. Verify Java installation (optional)
java -version

# 3. Install OpenJDK 17
sudo apt install openjdk-17-jre-headless -y

# 4. Add Jenkins key and repo
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# 5. Update and install Jenkins
sudo apt update
sudo apt install jenkins -y

# 6. Verify Jenkins version
jenkins --version

# 7. Retrieve initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## 🐳 Containerization Commands (Spring Boot + Docker)

```bash
# 1. Go to project directory
cd ~/spring_kannada_poets

# 2. Build the Spring Boot JAR
mvn clean package

# 3. Build Docker image
docker build -t spring_kannada_poets_app .

# 4. Verify image creation
docker images

# 5. Stop and remove old containers (if any)
docker ps -a
docker stop <container_id>
docker rm <container_id>

# 6. Run new container (map 8084 → 8080 inside container)
docker run -d -p 8084:8080 spring_kannada_poets_app

# 7. Verify running containers
docker ps
```

---

## 🐋 Docker Hub Integration

```bash
# 1. Tag the image
docker tag spring_kannada_poets_app abhi539/gatak:latest

# 2. Login to Docker Hub
docker login -u abhi539

# 3. Push image to Docker Hub
docker push abhi539/gatak:latest
```

---

## 🧱 Maven Installation (Ubuntu 24.04)

```bash
# Switch to root user
sudo su -

# Download Apache Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz

# Extract archive
tar -zxvf apache-maven-3.9.11-bin.tar.gz

# Remove tar file
rm -rf apache-maven-3.9.11-bin.tar.gz

# Rename directory
mv apache-maven-3.9.11 maven

# Add Maven to PATH
vi ~/.bashrc
# Add this line at the end:
export PATH=/root/maven/bin:$PATH

# Apply changes
source ~/.bashrc

# Verify installation
mvn --version
```

---

## 🐬 MySQL Installation (Ubuntu 24.04)

```bash
# Update and install MySQL
sudo apt update && sudo apt upgrade -y
sudo apt install mysql-server -y
sudo mysql --version

# Configure MySQL (inside MySQL shell)
sudo mysql
```

**Inside MySQL Shell:**

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
```

**Allow Remote Access:**

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change the line to:
bind-address = 0.0.0.0

# Restart MySQL
sudo systemctl restart mysql
```

---

## 🐳 Docker Installation (Ubuntu 24.04)

```bash
# Update packages
sudo apt update

# Install Docker
sudo apt install docker.io -y
sudo docker --version

# Install Docker Compose
sudo apt install docker-compose -y
docker-compose --version
```

---

## 🔧 Essential Jenkins Plugins

| **Plugin Name**           | **Purpose**                                 | **Rationale**                                                                               |
| ------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Pipeline (Workflow)**   | Enables running Jenkinsfiles.               | Required for Declarative and Scripted Pipelines.                                            |
| **Git**                   | Handles code checkout from GitHub.          | Needed for the `git` steps in the Checkout stage.                                           |
| **Pipeline: Basic Steps** | Provides shell execution and control steps. | Required for executing `sh` (Maven, Docker commands) and `echo`.                            |
| **Credentials Binding**   | Manages secure credentials usage.           | Used for Docker Hub credentials (`DOCKERHUB_CREDENTIALS_USR`, `DOCKERHUB_CREDENTIALS_PSW`). |
| **SSH Agent**             | Manages SSH private keys securely.          | Crucial for the *Deploy to EC2* stage and for `sshagent(['ubuntu'])` usage.                 |

---

✅ **Summary:**
This guide includes installation and setup for:

* Jenkins
* Maven
* Docker & Docker Hub
* MySQL
* Spring Boot containerization
* Essential Jenkins plugins

---

Would you like me to **add a final section for Jenkins Pipeline (Jenkinsfile)** — showing how it connects all these tools (build, Dockerize, push to Docker Hub, deploy to EC2)?
It’ll complete your README.md as a full CI/CD setup.
