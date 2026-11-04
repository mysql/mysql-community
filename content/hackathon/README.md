# OCI Hackathon Starter Kit

Get your hackathon project running on Oracle Cloud Infrastructure (OCI). The starter kit deploys the networking, compute, and optional databases you need to start building an application.

> [!WARNING]
> **Shut down cloud resources after use to avoid unexpected charges.** Once trial or promotional credits run out or expire, continued use of billable resources on a paid account can result in charges. Stop resources when you are not using them, and delete resources you no longer need. Stopped resources may still incur charges for storage or other retained components.

## What the starter kit deploys

- **Networking:** A virtual cloud network (VCN), subnets, security lists, a NAT gateway, and an internet gateway.
- **Application server:** A compute instance with Java, Node.js, Python, and MySQL Shell installed.
- **Database options:** MySQL HeatWave, Autonomous Database, or both. The MySQL option includes HeatWave capabilities and MySQL REST Service (MRS).

You can deploy the infrastructure through OCI Resource Manager using the same modules provided in this repository.

This guide uses the [stack ZIP](releases/oci-hackathon-starterkit-stack.zip) included in this folder.

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https%3A%2F%2Fgithub.com%2Fmysql%2Fmysql-community%2Fraw%2Frefs%2Fheads%2Fmain%2Fcontent%2Fhackathon%2Freleases%2Foci-hackathon-starterkit-stack.zip)

For more background, see the [Starter Kit wiki](https://github.com/lefred/oci-hackathon-starterkit/wiki).

## Follow the guide

Complete steps 1–3 to deploy your environment and connect to the application server. Then choose the sections that fit your project. Steps 5, 7, and 8 require MySQL HeatWave.

1. [Create your OCI account](#1-create-your-oci-account)
2. [Deploy the starter kit](#2-deploy-the-starter-kit)
3. [Connect to the compute instance](#3-connect-to-the-compute-instance)
4. [Choose your application language](#4-choose-your-application-language)
5. [Connect to MySQL HeatWave](#5-connect-to-mysql-heatwave)
6. [Use OCI Generative AI](#6-use-oci-generative-ai), including [API key and SDK setup](#set-up-your-oci-api-key-and-python-sdk)
7. [Use MySQL HeatWave GenAI](#7-use-mysql-heatwave-genai)
8. [Use MySQL REST Service](#8-use-mysql-rest-service)

- [Additional resources](#additional-resources)
- [Frequently asked questions](#frequently-asked-questions)

Screenshots and sample version numbers illustrate the environment used to prepare this guide. Your console screens and installed versions may differ.

## 1. Create your OCI account

If you already have a fully provisioned OCI account and have completed MFA enrollment, sign in and continue to step 2.

1. Open the [OCI sign-up page](https://signup.cloud.oracle.com/).
2. Enter your email address. If you registered for hackathon promotional credits, use the same address.
3. Follow the sign-up wizard and select **Individual** as your customer type.
4. **Select US Midwest (Chicago) as your Home Region for maximum AI model availability during this hackathon.**
5. Provide a supported payment method to verify your identity and activate the trial.

Oracle may place a temporary authorization hold on your card for verification. See the [Oracle Cloud Free Tier FAQ](https://www.oracle.com/cloud/free/faq/) for payment and trial details.

![OCI Signup](images/screenshot-01.png)

![Customer Type](images/screenshot-02.png)

### Select your Home Region

**Select US Midwest (Chicago) as your Home Region for maximum AI model availability during this hackathon.** Make this selection during sign-up, before completing account creation. Your Home Region cannot be changed after this step.

![Choose US Midwest (Chicago) in the Home Region menu](images/home-region-us-midwest-chicago.png)

![Payment Method 1](images/screenshot-03.png)

![Payment Method 2](images/screenshot-04.png)

### Wait for your account to be fully provisioned

After you complete sign-up, you'll see **“Please wait while we finish setting up your account…”**. Allow Oracle to finish provisioning your account before continuing.

![Account provisioning in progress](images/account-setup-slide-7-1.png)

> **You will receive an email with the subject “Your Oracle Cloud Account is Fully Provisioned”. Wait for this email before signing in and deploying the starter kit.**

### Sign in to your cloud account

Once you receive the provisioning email, open the [Oracle Cloud sign-in page](https://cloud.oracle.com/).

1. In **Cloud Account Name**, enter the account name you selected during sign-up.
2. Select **Next**.

The screenshots show an example account. Enter your own cloud account name.

![Enter the cloud account name selected during sign-up](images/account-setup-slide-8-1.png)

On the next screen, enter the **username and password you selected during sign-up**, then select **Sign In**.

![Sign in with your username and password](images/account-setup-slide-9-1.png)

### Configure multifactor authentication (MFA)

During your first sign-in, follow the prompts to enroll in secure verification.

1. On the **Enable Secure Verification** screen, select **Enable Secure Verification**.

![Enable secure verification for your account](images/account-setup-slide-10-1.png)

2. Select **Mobile App** as your verification method.
3. **Download the Oracle Mobile Authenticator app** to your phone from the Apple App Store or Google Play Store.
4. Open the app, tap **Add Account**, and scan the QR code displayed in your own browser session.
5. Complete the verification prompts until the browser displays **Successfully Enrolled**.
6. Select **Done**.

![MFA enrollment completed successfully](images/account-setup-slide-12-1.png)

### Open the OCI Console home screen

Once you're fully enrolled, you'll navigate to the **OCI Console home screen**. Check your trial status, then continue to step 2 to deploy the starter kit.

![OCI Console home screen after account provisioning and MFA enrollment](images/account-setup-slide-13-1.png)

## 2. Deploy the starter kit

With the OCI Console open, select **Deploy to Oracle Cloud** above or on the repository page. This opens the stack creation wizard in OCI Resource Manager.

![Deployment Button](images/screenshot-11.png)

![Resource Manager](images/screenshot-12.png)

### Choose your database

Select **MySQL HeatWave**, **Autonomous Database**, or **Both**.

| Option | What to configure |
| --- | --- |
| MySQL HeatWave | Enter your MySQL credentials and choose the database shape. The credential fields appear when you select this option. |
| Autonomous Database | Enter a database name that is unique in your tenancy and an ADMIN password. This stack uses a paid serverless configuration with 2 ECPUs and 20 GB of storage. |
| Both | Configure each database as described above. |

When MySQL HeatWave is selected, the stack defaults to the Always Free tier described in the original guide. You can choose a larger instance using trial or promotional credits. Review the selected configuration in the wizard before deploying.

![MySQL Shape](images/screenshot-13.png)

### Configure the application server

The compute instance defaults to:

- **Shape:** `VM.Standard.E5.Flex`
- **OCPUs:** 1
- **Memory:** 4 GB

This is a paid AMD shape that can use trial or promotional credits. You can select another supported shape and adjust its OCPU and memory settings. OCI selects the fault domain automatically.

![Application server configured with VM.Standard.E5.Flex, 1 OCPU, and 4 GB memory](images/compute-e5-flex.png)

### Create and apply the stack

1. Review your settings.
2. Select the option to **apply** the configuration.
3. Select **Create** to start deploying the resources.

![Apply Configuration](images/screenshot-15.png)

The deployment takes several minutes. Follow the job progress in Resource Manager and wait for the job to succeed.

![Deployment Progress](images/screenshot-16.png)

![Deployment Complete](images/screenshot-17.png)

If the job fails, check its logs for the cause. For an **out-of-host-capacity** error, try another supported shape or retry later. E5 capacity is not guaranteed.

When deployment finishes, review the outputs at the end of the job logs. You'll use the connection details in the next steps.

![Deployment Output](images/screenshot-18.png)

[Watch the deployment walkthrough](https://github.com/user-attachments/assets/3cda5c48-1189-4dc4-9036-b17ba17da71c)

## 3. Connect to the compute instance

You'll need the generated SSH private key and the compute instance's public IP address.

### Save the SSH key

1. In the OCI Console, open **Resource Manager → Stacks** and select your stack.
2. Open **Application Information → Generated SSH private key**.
3. Copy the entire key into a local file named `key.pem`.
4. Copy the compute instance's public IP address from the same screen.

![Generated SSH private key and compute connection details](images/screenshot-19.png)

![SSH private key saved to a local file](images/screenshot-20.png)

### Open an SSH connection

On macOS or Linux, restrict access to the key file:

```shell
chmod 600 key.pem
```

Then connect as the `opc` user. Replace `<compute-public-ip>` with your instance's public IP address:

```shell
ssh -i key.pem opc@<compute-public-ip>
```

![SSH Connection](images/screenshot-21.png)

You're now connected to the application server. Unless a step says otherwise, run the remaining shell commands on this instance.

[Watch the SSH connection walkthrough](https://github.com/user-attachments/assets/75f96eed-cb99-4b56-b27d-7cdb51bb4c53)

## 4. Choose your application language

The compute instance includes Java, Node.js, and Python. Check your instance before you start; Node.js and Python versions depend on the image and repositories.

| Language | Installed version | Check your version |
| --- | --- | --- |
| Java | Highest available Oracle JDK major version | `java --version` |
| Node.js | 16 | `node --version` |
| Python | 3.9 | `python3 --version` |

### Java

New compute instances query the Oracle Linux 9 OCI Included repository (`ol9_oci_included`) and install the highest available Oracle JDK major version for their architecture (Intel/AMD x64 or Arm64). The `jdk-<major>-headful` package provides the full development kit, including the compiler, and pulls in the matching headless runtime. Maven is also installed.

The selected Oracle JDK is the default for both `java` and `javac`. Login shells set `JAVA_HOME` to `/usr/java/jdk-<major>` for that release.

Verify the installed version after connecting:

```shell
$ java --version
$ javac --version
$ mvn --version
```

The version is selected at instance creation, so future major releases require no version edits to this script. Selection follows availability in Oracle's repository, which may lag a release announcement. If the repository cannot be queried or has no matching package, provisioning stops with an error. This requires the OCI repository configuration included in standard OCI Oracle Linux 9 images. See [Oracle's JDK repository guide](https://yum.oracle.com/oracle-linux-java.html). Existing instances are not automatically upgraded.


### Install Python 3.12

If your application needs Python 3.12, install it alongside the default version:

```shell
sudo dnf install -y python3.12
python3.12 --version
```

Use `python3.12` when running applications that require this version. See [Installing Python on Oracle Linux 9](https://docs.oracle.com/en/operating-systems/oracle-linux/9/python/python-InstallingPython.html) for package availability.

[Watch the language setup walkthrough](https://github.com/user-attachments/assets/c2bd05d5-2af0-4ea3-917e-9eca31b3c1b0)

## 5. Connect to MySQL HeatWave

**Prerequisite:** You selected MySQL HeatWave during deployment.

Choose one of these connection methods:

| Method | Where you connect from | What you need |
| --- | --- | --- |
| MySQL Shell | The compute instance | SSH access and the database's private IP address |
| MySQL Shell for Visual Studio Code | Your local machine | OCI API credentials and a bastion connection |
| OCI Cloud Shell | The OCI Console | An ephemeral private network connected to your VCN and private subnet |

### Option A: MySQL Shell on the compute instance

MySQL Shell (`mysqlsh`) is already installed on the compute instance.

1. Connect to the compute instance over SSH as described in [step 3](#3-connect-to-the-compute-instance).
2. Find your MySQL HeatWave DB system's private IP address in the deployment outputs or on the DB system's **Connections** tab in the OCI Console.
3. On the compute instance, run the following command. Replace `<private-ip>` with that address:

```shell
mysqlsh admin@<private-ip>
```

If you chose a different MySQL administrator username during deployment, replace `admin` with that username. When prompted, enter the MySQL password you supplied during deployment.

Once connected, switch MySQL Shell to SQL mode to run the SQL examples in this guide:

```text
\sql
```

Check the connection:

```sql
SELECT @@version;
```

[Watch the MySQL Shell walkthrough](https://github.com/user-attachments/assets/3d4e3030-d350-4600-bb54-c3c16f7344a4)

### Option B: MySQL Shell for Visual Studio Code

On your local machine, follow the [API key and configuration steps](#set-up-your-oci-api-key-and-python-sdk) in section 6. Then use MySQL Shell for Visual Studio Code to connect to the DB system through a bastion host. The Python SDK installation is needed for the Python examples, not for this Visual Studio Code connection.

[Watch the Visual Studio Code walkthrough](https://github.com/user-attachments/assets/0940835d-7b26-4cb9-b96a-b11ecb29de54)

### Option C: OCI Cloud Shell

Open Cloud Shell from the OCI Console. Configure an **ephemeral private network** using your VCN and private subnet, then connect to the DB system using its private IP address.

[Watch the Cloud Shell walkthrough](https://github.com/user-attachments/assets/8fc02692-b81a-49f4-be8f-a8fe079b390e)

## 6. Use OCI Generative AI

OCI Generative AI lets you call models from your application using SDKs and generated sample code, including Java and Python examples.

### Set up your OCI API key and Python SDK

Complete this setup before running a Python example that uses OCI. Store the configuration and API private key on the machine running your code: your laptop for local development, or the compute instance for the examples below.

The **API signing key** authenticates OCI API requests. Keep it separate from the **SSH key** (`key.pem`) used to connect to your compute instance.

#### Generate and download the API key

Start on your **local machine**. On macOS or Linux, create a credentials directory:

```shell
mkdir -p ~/.oci
chmod 700 ~/.oci
```

In the OCI Console:

1. Open the profile menu and select **User settings**.
2. Open **API Keys** (your console layout may group these under **Tokens and keys**).
3. Select **Add API Key → Generate API Key Pair**.
4. Select **Download Private Key** before closing the dialog. Save the file as `~/.oci/oci_api_key.pem`; if it downloads elsewhere, move it there.
5. Select **Add** to register the public key.
6. Copy the **Configuration File Preview** snippet for the next step.

For an existing key, use its actions menu and select **View configuration file** to retrieve the snippet. You must already have its private key; if you've lost it, generate a new pair. See [Oracle's API signing key instructions](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm).

#### Create or update `~/.oci/config`

Open the file in an editor:

```shell
nano ~/.oci/config
```

Paste the console snippet and update `key_file`. A complete profile looks like this:

```ini
[DEFAULT]
user=<user-ocid>
fingerprint=<api-key-fingerprint>
tenancy=<tenancy-ocid>
region=<oci-region>
key_file=/absolute/path/to/.oci/oci_api_key.pem
```

Use the actual values from the console. On the compute instance, the key path is normally `/home/opc/.oci/oci_api_key.pem`. On your laptop, use the full path to the downloaded file.

| Field | What to check |
| --- | --- |
| `user` | The OCID of the user whose API key you added |
| `fingerprint` | The fingerprint of that same key |
| `tenancy` | Your tenancy's OCID |
| `region` | The region used by your application, for example `us-chicago-1`; for Generative AI, match the selected model's region |
| `key_file` | The private key's location on the machine running your code |

If `[DEFAULT]` already exists, update that section or add a named profile such as `[HACKATHON]`. Avoid duplicate `[DEFAULT]` sections. These examples use `DEFAULT`.

Save the file, then restrict access:

```shell
chmod 600 ~/.oci/config ~/.oci/oci_api_key.pem
```

Keep private keys out of Git repositories and shared documents. See the [OCI configuration file reference](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm) for profile settings. If your key is passphrase-protected, supply its passphrase at runtime.

#### Set up the credentials on the compute instance

For a demo running on the compute instance, create its credentials directory over SSH:

```shell
mkdir -p ~/.oci
chmod 700 ~/.oci
```

From your **local machine**, copy the API private key to the instance. These commands assume the local key is named `oci_api_key.pem` and the SSH key is `key.pem` in your current directory:

```shell
scp -i key.pem ~/.oci/oci_api_key.pem opc@<compute-public-ip>:.oci/oci_api_key.pem
```

If the destination key already exists, choose a different filename and update `key_file` accordingly.

Back on the **compute instance**, create or update the configuration using the same console snippet:

```shell
nano ~/.oci/config
```

Set `key_file=/home/opc/.oci/oci_api_key.pem`, then protect both files:

```shell
chmod 600 ~/.oci/config ~/.oci/oci_api_key.pem
```

#### Install the Python SDK and dependencies

On the **compute instance**, install Python 3.12 and pip, then create a project environment:

```shell
sudo dnf install -y python3.12 python3.12-pip
mkdir -p ~/hackathon-app
cd ~/hackathon-app
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install oci
```

The `python3.12-pip` package provides pip for this interpreter; see [Oracle Linux Python package installation](https://docs.oracle.com/en-us/iaas/oracle-linux/python/python-installing-third-party-packages.htm). The `oci` package installs the OCI Python SDK and its dependencies. A virtual environment keeps these separate from system packages. See the [OCI Python SDK installation guide](https://docs.oracle.com/en-us/iaas/tools/python/latest/installation.html).

For **local development on macOS or Linux**, use an installed Python 3.12 interpreter and run the same commands starting at `mkdir -p ~/hackathon-app`; the `dnf` command is for the Oracle Linux compute instance.

When you reconnect to the instance, activate the environment again:

```shell
cd ~/hackathon-app
source .venv/bin/activate
```

With this environment active, `python` and `python -m pip` use the same interpreter. Install any additional packages required by your sample code into this environment. For example, the MySQL examples also require:

```shell
python -m pip install mysql-connector-python
```

#### Verify the local setup

Save this as `check_oci.py` in your project folder:

```python
from pathlib import Path
import oci

config = oci.config.from_file()
oci.config.validate_config(config)
key_path = Path(config["key_file"]).expanduser()
if not key_path.is_file():
    raise FileNotFoundError(f"API private key not found: {key_path}")

# Constructing a client also checks that the signing key can be loaded.
client = oci.identity.IdentityClient(config)
print(f"OCI SDK {oci.__version__}: configuration and signing key loaded")
```

Run it:

```shell
python check_oci.py
```

For a named profile, change the loading line to:

```python
config = oci.config.from_file(profile_name="HACKATHON")
```

This check loads the configuration and key locally. It doesn't make an API request or verify IAM permissions. Your user must have access to the services and compartment used by the demo. See the [Python SDK configuration guide](https://docs.oracle.com/en-us/iaas/tools/python/latest/configuration.html).

#### Optional: install the OCI CLI

The Python demo uses the SDK. If you also want the `oci` terminal command, install the CLI in your active environment:

```shell
python -m pip install oci-cli
oci --version
```

The CLI can use the same `~/.oci/config`. See [Oracle's manual CLI installation guide](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/climanualinst.htm).

#### Troubleshoot common setup issues

- **`No module named oci`:** Activate `.venv` and run `python -m pip install oci` with the interpreter that runs your demo.
- **Configuration or key file not found:** Check the files on the machine running your script and confirm the `key_file` path.
- **Authentication error:** Check that the user OCID, fingerprint, and private key belong to the same registered API key.
- **Permission or service access error:** Check the user's IAM policies, target compartment, service region, and the endpoint in the generated code.

### Generate sample code

> **For the Free Trial, use the Cohere model shown below: `cohere.command-a-03-2025 v1.0`. Grok is not supported in the Free Trial.**

1. In the OCI Console, open **Generative AI → Playground → Chat**.
2. Select your compartment and choose **`cohere.command-a-03-2025 v1.0`** from the **Model** menu. The screenshots use **US Midwest (Chicago)**.

![Select the Cohere Command A model for the Free Trial](images/generative-ai-cohere-model.png)

3. Choose an example prompt or enter your own. The screenshot below uses **Generate a job description** and shows the Cohere model's response.

![Cohere model response in the Generative AI playground](images/generative-ai-cohere-playground.png)

4. Select **View code**, choose **Python**, and copy the generated sample code. Generate the code after selecting Cohere so it uses the correct model and regional endpoint.

### Run the example on your compute instance

Complete the [API key and Python SDK setup](#set-up-your-oci-api-key-and-python-sdk) above on the compute instance, then activate your project environment:

```shell
cd ~/hackathon-app
source .venv/bin/activate
```

Save the generated Python example as `~/hackathon-app/demo.py` and update the input prompt. Confirm that the code loads the configuration profile you created and uses the intended compartment and regional endpoint. Install any additional dependencies called out by the sample using `python -m pip install <package-name>`.

Run the example from your active environment:

```shell
python demo.py
```

[Watch the OCI Generative AI walkthrough](https://github.com/user-attachments/assets/edb32d97-1532-44bf-a5b2-2269f7b24522). The video shows an earlier interface; use the Cohere model and screenshots above for the Free Trial.

## 7. Use MySQL HeatWave GenAI

**Prerequisite:** You deployed MySQL HeatWave and can connect to the DB system.

You can also call GenAI procedures directly from MySQL HeatWave. Start by checking that your application can connect to the database, then call the GenAI procedure.

### Install the Python connector

Use the project environment created in [section 6](#set-up-your-oci-api-key-and-python-sdk). On the compute instance:

```shell
cd ~/hackathon-app
source .venv/bin/activate
python -m pip install mysql-connector-python
```

Keep this environment active when running the scripts below. The MySQL examples use database credentials; they do not require OCI API credentials.

### Test the database connection

Save this example as `test_hw.py`. Replace `<database-private-ip>`, `<mysql-user>`, and `<mysql-password>` with your deployment details.

```python
import mysql.connector

conn = mysql.connector.connect(
    host="<database-private-ip>",
    user="<mysql-user>",
    password="<mysql-password>",
)

cursor = conn.cursor()
cursor.execute("SELECT @@version")

for row in cursor.fetchall():
    print(row)

cursor.close()
conn.close()
```

Run it:

```shell
python test_hw.py
```

The script prints your database version. For example:

```text
('9.4.1-cloud',)
```

### Call HeatWave Chat

In the same script, replace the version query with:

```python
cursor.execute(
    "CALL sys.HEATWAVE_CHAT(%s)",
    ("What is MySQL HeatWave?",),
)
```

Run the script again to see the response.

![MySQL HeatWave GenAI](images/screenshot-24.png)

See the [MySQL HeatWave GenAI documentation](https://dev.mysql.com/doc/heatwave/en/mys-hw-genai.html) for available capabilities and requirements.

[Watch the MySQL HeatWave GenAI walkthrough](https://github.com/user-attachments/assets/c3f3eb3f-3260-406b-9fd2-bbf828747c90)

## 8. Use MySQL REST Service

**Prerequisite:** You deployed the MySQL option and configured MySQL Shell for Visual Studio Code as described in step 5.

The starter kit deploys MySQL REST Service (MRS) with the MySQL configuration. MRS exposes database resources through REST endpoints so your application can work with data without writing SQL for each request. It can also expose selected HeatWave GenAI functionality.

Review your deployment outputs for the service connection details:

![MRS New](images/screenshot-25.png)

<details>
<summary>Compare with the earlier deployment output</summary>

![MRS Previous](images/screenshot-26.png)

</details>

### Grant MRS administration access

Connect to MySQL as your database administrator and grant the MRS role. The examples below use the `admin` account; substitute your account name if it differs.

```sql
GRANT 'mysql_rest_service_admin' TO 'admin'@'%';
SET DEFAULT ROLE ALL TO 'admin'@'%';
```

Disconnect and reconnect to activate the role in your session.

### Create sample data

In MySQL Shell for Visual Studio Code, create a database and table, then insert three records:

```sql
CREATE DATABASE myproject;
USE myproject;

CREATE TABLE myrecords (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO myrecords (name)
VALUES ('Scott'), ('Miguel'), ('Fred');
```

### Expose the table through MRS

1. Create a REST service named **MyService** with the request path `/myService`.
2. Add the `myproject` schema and `myrecords` table to the service.
3. If prompted to add the schema while adding the table, select **Yes**.

![MRS Setup 1](images/screenshot-27.png)

![MRS Setup 2](images/screenshot-28.png)

![MRS Setup 3](images/screenshot-29.png)

![MRS Setup 4](images/screenshot-30.png)


![MRS Schema Add](images/screenshot-32.png)

### Create a service user

With the default **MySQL** authentication app enabled, create the user you'll use to sign in to the service:

```sql
CREATE USER 'myrest' IDENTIFIED BY '<rest-password>';
```

Replace `<rest-password>` with your chosen password. Use the same password in the requests below.

### Access data with curl

On the compute instance, set the base URL to the MRS endpoint from your deployment outputs, including the `/myService` path:

```shell
MRS_BASE_URL='https://<mrs-host>/myService'
```

Authenticate and save the session cookie:

```shell
curl -c cookie.txt -k -X POST \
  -H 'Content-Type: application/json' \
  -d '{"username":"myrest","password":"<rest-password>","authApp":"MySQL"}' \
  "$MRS_BASE_URL/authentication/login"
```

Retrieve the records:

```shell
curl -s -b cookie.txt -k \
  "$MRS_BASE_URL/myproject/myrecords" | jq
```

The response contains the records and pagination metadata. To retrieve the record with ID `2`:

```shell
curl -s -b cookie.txt -k \
  "$MRS_BASE_URL/myproject/myrecords/2" | jq
```

For the sample data above, ID `2` corresponds to **Miguel**.

The walkthrough uses `-k` for the demo endpoint's TLS certificate. This option skips certificate verification.

[Watch the MRS setup walkthrough](https://github.com/user-attachments/assets/8b7fc207-44a5-44db-8c64-399bbd878f2c)

### Access data with the Python SDK

You can generate an SDK for your REST service in MySQL Shell for Visual Studio Code.

1. Download the SDK for **MyService**.
2. Select **Python** and set the service URL to the endpoint your compute instance can reach.
3. Copy the downloaded SDK folder to the compute instance.

![SDK Download](images/screenshot-33.png)

![SDK Config](images/screenshot-34.png)

![SDK Package](images/screenshot-35.png)

The commands below assume the downloaded folder is named `myService.mrs.sdk`. Substitute the actual folder name if yours differs.

Run this command on your **local machine**:

```shell
scp -i key.pem -r myService.mrs.sdk opc@<compute-public-ip>:
```

Then run these commands on the **compute instance**:

```shell
mkdir -p myproject
mv myService.mrs.sdk myproject/sdk
cd myproject
```

Install the dependencies listed in the generated SDK's instructions using Python 3.12.

Save your application as `project.py`. The example below follows the SDK layout and `read()` API shown in the original walkthrough:

```python
import asyncio

from sdk.my_service import MyService

my_service = MyService(verify_tls_cert=False)

async def main():
    await my_service.authenticate(
        username="myrest",
        password="<rest-password>",
    )

    records = await my_service.myproject.myrecords.read()
    for record in records:
        print(record.name)

    await my_service.myproject.myrecords.create(data={"name": "Lenka"})

asyncio.run(main())
```

Replace `<rest-password>` before running the script:

```shell
python3.12 project.py
```

The script prints the existing names and inserts a new record for Lenka. Running it again inserts another record.

**SDK version note:** Generated module paths and methods vary by SDK version. The current [MRS SDK reference](https://dev.mysql.com/doc/dev/mysql-rest-service/latest/sdk.html) documents `find()` for reading records and an `app` argument for authentication. If your generated SDK differs from the walkthrough, follow its included examples and matching API documentation.

Like `curl -k`, `verify_tls_cert=False` skips certificate verification for this demo connection.

[Watch the SDK walkthrough](https://github.com/user-attachments/assets/45e34c29-3eea-4804-a493-0736e0aedb1c)

## Additional resources

- [Starter Kit wiki](https://github.com/lefred/oci-hackathon-starterkit/wiki)
- [Stack ZIP](releases/oci-hackathon-starterkit-stack.zip)
- [Oracle Cloud Free Tier FAQ](https://www.oracle.com/cloud/free/faq/)
- [MySQL HeatWave GenAI documentation](https://dev.mysql.com/doc/heatwave/en/mys-hw-genai.html)
- [MRS quickstart](https://dev.mysql.com/doc/dev/mysql-rest-service/latest/quickstart.html)
- [MRS SDK reference](https://dev.mysql.com/doc/dev/mysql-rest-service/latest/sdk.html)

## Frequently asked questions

### What does the starter kit actually do?

It deploys the network, an application server, and your selected databases so you can spend more time building your project.

### Do I need to know Terraform or cloud networking?

You can deploy through the OCI Console using the guided Resource Manager stack. This guide walks through the settings.

### Is everything free?

Some resources use trial or promotional credits. The default E5.Flex application server and the stack's Autonomous Database configuration are paid resources. Free Trial and Always Free have different limits. See the [Oracle Free Tier FAQ](https://www.oracle.com/cloud/free/faq/).

For your hackathon's credit amount and expiry, check with the organizers.

### Why do I need a payment card? Will I be charged?

Oracle uses it for identity verification and may place a temporary authorization hold. You must explicitly upgrade to a paid account before paid usage is billed. See the [Oracle Free Tier FAQ](https://www.oracle.com/cloud/free/faq/).

### When can I start deploying?

Wait for the **“Your Oracle Cloud Account is Fully Provisioned”** email, then sign in and complete MFA enrollment using Oracle Mobile Authenticator.

### What if deployment fails?

Open the Resource Manager job logs first. If the error says **out of host capacity**, try another supported compute shape or retry later.

### Which database should I select?

Choose MySQL HeatWave to follow this guide's MySQL, HeatWave GenAI, and REST examples. Choose Autonomous Database for a project that needs Oracle Database. Select both if your project needs both.

### Which AI model should we use?

Follow the workshop's **Cohere Command A** example. This Free Trial walkthrough uses Cohere rather than Grok. Match the model and region shown in [section 6](#generate-sample-code).

### What's the difference between OCI Generative AI and HeatWave GenAI?

OCI Generative AI is called from your application through an API or SDK. The HeatWave example calls a GenAI procedure directly from MySQL.

### Are the SSH key and OCI API key the same?

They're separate credentials. The SSH key connects you to the application server. The API signing key authenticates your application's OCI requests.

### Why does my Python example say `No module named oci`?

Activate the project's virtual environment and install the SDK with `python -m pip install oci`. Use that same environment to run the example. See the [API key and SDK setup](#set-up-your-oci-api-key-and-python-sdk) for the complete steps.

### How do we clean up after the hackathon?

Save your code and export any data you need, then run a **Destroy** job for the Resource Manager stack. This tears down the resources managed by that stack. See the [Destroy job instructions](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/create-job-destroy.htm).

> [!WARNING]
> **Shut down cloud resources after use to avoid unexpected charges.** Once trial or promotional credits run out or expire, continued use of billable resources on a paid account can result in charges. Stop resources when you are not using them, and delete resources you no longer need. Stopped resources may still incur charges for storage or other retained components.

[Back to the table of contents](#follow-the-guide)
