# Installing and Configuring the Element Chat Application

Ref: https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/

[_Element_](https://element.io/) is a free open source chat and messaging client that is an alternative to Discord and Slack. It implements communication protocols from the [_Matrix_](https://matrix.org/) application layer using _end-to-end encryption_ (E2EE). Formerly known as Riot and before that as Vector, Element is available as either a web application or a desktop/mobile app. This guide explains how to download and install both Element and the Matrix-Synapse communication layer. It also describes how to set up encryption and use these applications with the NGINX web server.

[## Before You Begin](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#before-you-begin)

1. If you have not already done so, create a Linode account and Compute Instance. See our [Getting Started with Linode](https://www.linode.com/docs/products/platform/get-started/) and [Creating a Compute Instance](https://www.linode.com/docs/products/compute/compute-instances/guides/create/) guides.
2. Follow our [Setting Up and Securing a Compute Instance](https://www.linode.com/docs/products/compute/compute-instances/guides/set-up-and-secure/) guide to update your system. You may also wish to set the timezone, configure your hostname, create a limited user account, and harden SSH access.
3. Register a _Fully Qualified Domain Name_ (FQDN) for your Element service. The DNS records for the domain should be set to the IP address of your Linode. Consult Linode’s [DNS Records: An Introduction](https://www.linode.com/docs/guides/dns-overview/) and [DNS Manager](https://www.linode.com/docs/products/networking/dns-manager/) guides for assistance when configuring your domain.

This guide is written for a non-root user. Commands that require elevated privileges are prefixed with `sudo`. If you are not familiar with the `sudo` command, see the [Linux Users and Groups](https://www.linode.com/docs/guides/linux-users-and-groups/) guide.

[## Advantages and Features of Element](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#advantages-and-features-of-element)

1. Element offers features such as voice and group chat, video calls, and file sharing. It prioritizes security through the use of _end-to-end encryption_ (E2EE) and _cross-signed verification_. Due to its open-source status and its governance by the Matrix.org Foundation, it is free from corporate influences. This means users are protected from eavesdropping, data mining, and intrusive ads.
2. Element also provides _bridges_, which allow Element users to communicate with other applications and networks such as IRC, Slack, Telegram, and Discord. Bots and widgets allow users to view or import content, such as GitHub results, Wikipedia pages, and RSS feeds.
3. Although the core version of Element is free for basic users, several commercial upgrades are available. _Element Home_ is a paid service featuring more accounts and extra features, while _Element Matrix Services_ is geared towards businesses. Element can even support large organizations and governments.

Element is based on React and uses _Electron_ for bundling. See the [_Element GitHub Page_](https://github.com/vector-im/element-web) to learn more, including how to develop in Element.

[## A Summary of the Element Installation and Configuration Process](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#a-summary-of-the-element-installation-and-configuration-process)

A complete Element installation consists of the high-level steps outlined in this section. Because Element is a web client for [_Matrix-Synapse_](https://matrix.org/docs/projects/server/synapse), you must first download and install the Matrix-Synapse software package. Element also requires a web server, such as [_NGINX_](https://www.linode.com/docs/guides/web-servers/nginx/). Although these instructions are geared towards Ubuntu installations, they are broadly applicable to most Linux distributions.

1. Set Up DNS Records
2. Download and install the Matrix-Synapse communication layer
3. Download, install, and configure the Element client
4. Install and configure the NGINX web server
5. Install Certbot and generate _Let’s Encrypt_ certificates
6. Configure security settings for Element
7. Enable and test the Element client

The following sections describe each step in more detail.

[## Set Up DNS Records](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#set-up-dns-records)

- Before connecting to Element, register a base domain for your service and [set the corresponding DNS records](https://www.linode.com/docs/guides/dns-overview/) to reference your Linode.
- Create two further subdomains for the _matrix_ and _element_ services, each with its DNS records.
- Create DNS records for the following domains and subdomains:

  - `example.com` (general website and hosting for the Matrix services)
  - `example.com` (general website and hosting for the Matrix services)
  - `matrix.example.com` (Matrix/Synapse communication layer)
  - `element.example.com` (Element web client)

    Throughout this section and the rest of the guide, replace `example.com` with your own domain name. See the guide for the Linode [DNS Manager](https://www.linode.com/docs/products/networking/dns-manager/) for more information on adding domains and DNS records.

[## Download and Install the Matrix-Synapse Communication Layer](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#download-and-install-the-matrix-synapse-communication-layer)

Install the _Matrix-Synapse_ service. Element depends on Matrix functionality to work properly.

Synapse is the “home server” implementation of Matrix, but the two names are often used interchangeably. This guide refers to the software package as _Matrix_ and the actual component as _Matrix-Synapse_ to avoid confusion.

1. Ensure the necessary software dependencies are installed.

   ```
    sudo apt install -y lsb-release wget apt-transport-https
   ```

2. Download the Matrix Organization’s GPG key.

   ```
    sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
   ```

3. Add the Matrix repository.

   ```
    echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/matrix-org.list
   ```

4. Use `apt` to install Matrix.

   ```
    sudo apt-get update -y
    sudo apt-get install matrix-synapse-py3 -y
   ```

5. During the installation process, Matrix asks for the name of your domain. Enter the name of the `matrix` subdomain.

   For the `Anonymous Data Statistic`, choose **No**.

   ![Matrix domain name prompt](/docs/guides/how-to-install-the-element-chat-app/Matrix-Domain-Prompt_small_hu88ce5298e72a9bd68d317b0a2a71805a_42282_694x0_resize_q71_bgfafafc_catmullrom_3.jpg "Matrix domain name prompt")

6. Edit the Matrix-Synapse configuration file at `/etc/matrix-synapse/homeserver.yaml` and set `enable_registration` to true.

   ```
    vi /etc/matrix-synapse/homeserver.yaml
   ```

   File: /etc/matrix-synapse/homeserver.yaml

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt">1
   </span><span class="lnt">2
   </span><span class="lnt">3
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl">...
   </span></span><span class="line"><span class="cl">enable_registration: <span class="nb">true</span>
   </span></span><span class="line"><span class="cl">...</span></span></code></pre></td></tr></tbody></table>

7. **(Optional)** To limit who can register, uncomment the `registration_shared_secret` field in the `homeserver.yaml` file. Set the value of this field to a secure password and enclose it in quotation marks. This allows users to register, provided they know the password, even when `enable_registration` is set to `false`.

   File: /etc/matrix-synapse/homeserver.yaml

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt">1
   </span><span class="lnt">2
   </span><span class="lnt">3
   </span><span class="lnt">4
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl">...
   </span></span><span class="line"><span class="cl">registration_shared_secret: <span class="s2">"your_password"</span>
   </span></span><span class="line"><span class="cl">...
   </span></span><span class="line"><span class="cl">    </span></span></code></pre></td></tr></tbody></table>

8. **(Optional)** To enable additional features based on email lookups and bridging with other applications, configure an _identity server_ for Element to use. You can use your own Linode, the default server at `https://matrix.org`, or a third-party service. Uncomment the `default_identity_server` entry inside the `/etc/matrix-synapse/homeserver.yaml` file and enter the address of the server. Even without an identity server, Element still functions normally and its core features are still available.
9. Restart Matrix-Synapse to apply the changes, and then verify its status.

   ```
    sudo systemctl restart matrix-synapse
    sudo systemctl status matrix-synapse
   ```

   Matrix should indicate a status of `active`.

   ```
   matrix-synapse.service - Synapse Matrix homeserver
   Loaded: loaded (/lib/systemd/system/matrix-synapse.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2021-04-08 10:56:34 UTC; 8s ago
   ```

10. To allow Element and other clients to find Matrix-Synapse, create a `.well-known` file for it. This file must contain the `hostname` and `port`. Substitute your own domain name for `example.com` in the following commands.

    ```
     sudo mkdir -p /var/www/html/example.com/.well-known/matrix
     echo '{ "m.server": "example.com:443" }' | sudo tee /var/www/html/example.com/.well-known/matrix/server
    ```

For more advanced installation instructions, see the [_Matrix-Synapse GitHub installation page_](https://github.com/matrix-org/synapse/blob/master/INSTALL.md). This page includes instructions for building from source and configuring Matrix-Synapse using Docker or Ansible.

Earlier versions of Matrix, as well as development/beta releases, are available on the [_Matrix releases page_](https://github.com/matrix-org/synapse/releases).

[## Download, Install, and Configure the Element Client](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#download-install-and-configure-the-element-client)

Software packages for installing Element are found on the [_Element releases page_](https://github.com/vector-im/element-web/releases). Download the `tar` file to your Linode using `wget`. The current version of Element is 1.7.24. When downloading the files, substitute the actual version you are downloading in place of `1.7.24`.

1. Create a directory for Element inside `/var/www/html` and change to the directory. Substitute your domain name for `example.com` in the following commands.

   ```
    sudo mkdir -p /var/www/html/element.example.com
    cd /var/www/html/element.example.com
   ```

2. Download the Element software using `wget`.

   ```
    sudo wget https://github.com/vector-im/element-web/releases/download/v1.7.24/element-v1.7.24.tar.gz
   ```

3. Install `gnupg` and download the signature.

   ```
    sudo apt install -y gnupg
    sudo wget https://github.com/vector-im/element-web/releases/download/v1.7.24/element-v1.7.24.tar.gz.asc
   ```

4. Import the signing key for Element.

   ```
    sudo gpg --keyserver keyserver.ubuntu.com --search-keys releases@riot.im
   ```

   The `gpg` utility confirms the key is imported.

   ```
   gpg: key 74692659BDA3D940: public key "Riot Releases <releases@riot.im>" imported
   gpg: Total number processed: 1
   gpg: imported: 1

   ```

5. Use this key to validate the `asc` signature.

   ```
    sudo gpg --verify element-v1.7.24.tar.gz.asc
   ```

   `gpg` confirms the signature is good.

   ```
   gpg: assuming signed data in 'element-v1.7.24.tar.gz'
   gpg: Signature made Mon Mar 29 12:44:56 2021 UTC
   gpg: using RSA key 5EA7E0F70461A3BCBEBE4D5EF6151806032026F9
   gpg: issuer "releases@riot.im"
   gpg: Good signature from "Riot Releases <releases@riot.im>" [unknown]

   ```

6. Extract the Element software using the `tar` utility.

   ```
    sudo tar -xzvf element-v1.7.24.tar.gz
   ```

7. Create an alias for the application to make it easier to remember and set the ownership.

   ```
    sudo ln -s element-v1.7.24 element
    sudo chown www-data:www-data -R element
   ```

8. Change to the `element` directory, and create a copy of the `config.sample.json` file named `config.json`.

   ```
    cd element
    sudo cp config.sample.json config.json
   ```

9. Edit the `base_url` and `server_name` attributes in `config.json` so they reference your domain. The `base_url` value must reference the `matrix` subdomain, while `server_name` must indicate the base domain.

   File: /var/www/html/element.example.com/element/config.json

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt"> 1
   </span><span class="lnt"> 2
   </span><span class="lnt"> 3
   </span><span class="lnt"> 4
   </span><span class="lnt"> 5
   </span><span class="lnt"> 6
   </span><span class="lnt"> 7
   </span><span class="lnt"> 8
   </span><span class="lnt"> 9
   </span><span class="lnt">10
   </span><span class="lnt">11
   </span><span class="lnt">12
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl"><span class="o">{</span>
   </span></span><span class="line"><span class="cl">    <span class="s2">"default_server_config"</span>: <span class="o">{</span>
   </span></span><span class="line"><span class="cl">        <span class="s2">"m.homeserver"</span>: <span class="o">{</span>
   </span></span><span class="line"><span class="cl">            <span class="s2">"base_url"</span>: <span class="s2">"https://matrix.example.com"</span>,
   </span></span><span class="line"><span class="cl">            <span class="s2">"server_name"</span>: <span class="s2">"example.com"</span>
   </span></span><span class="line"><span class="cl">        <span class="o">}</span>,
   </span></span><span class="line"><span class="cl">        <span class="s2">"m.identity_server"</span>: <span class="o">{</span>
   </span></span><span class="line"><span class="cl">            <span class="s2">"base_url"</span>: <span class="s2">"https://example.com"</span>
   </span></span><span class="line"><span class="cl">        <span class="o">}</span>
   </span></span><span class="line"><span class="cl">    <span class="o">}</span>,
   </span></span><span class="line"><span class="cl">...
   </span></span><span class="line"><span class="cl">    </span></span></code></pre></td></tr></tbody></table>

[## Install and Configure the NGINX Web Server](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#install-and-configure-the-nginx-web-server)

You must install [_NGINX_](https://www.nginx.com/) before using Certbot. For more information about NGINX, see Linode’s [How to Configure NGINX](https://www.linode.com/docs/guides/how-to-configure-nginx/) guide.

1. Install NGINX.

   ```
    sudo apt -y install nginx
   ```

2. Create files for each virtual host, corresponding to each domain, and link the directories using the `ln` command. Substitute the name of your domain for `example.com` throughout the rest of this section.

   ```
    sudo touch /etc/nginx/sites-available/{example.com,matrix.example.com,element.example.com}
    sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
    sudo ln -s /etc/nginx/sites-available/matrix.example.com /etc/nginx/sites-enabled/matrix.example.com
    sudo ln -s /etc/nginx/sites-available/element.example.com /etc/nginx/sites-enabled/element.example.com
   ```

3. Change to the `/etc/nginx/sites-available` directory and add the following information to the file associated with the base domain, in this case, `example.com`. Use your domain for the `server_name` and `root` variables.

   ```
    cd /etc/nginx/sites-available
    vi example.com
   ```

   File: /etc/nginx/sites-available/example.com

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt"> 1
   </span><span class="lnt"> 2
   </span><span class="lnt"> 3
   </span><span class="lnt"> 4
   </span><span class="lnt"> 5
   </span><span class="lnt"> 6
   </span><span class="lnt"> 7
   </span><span class="lnt"> 8
   </span><span class="lnt"> 9
   </span><span class="lnt">10
   </span><span class="lnt">11
   </span><span class="lnt">12
   </span><span class="lnt">13
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-nginx" data-lang="nginx"><span class="line"><span class="cl"><span class="k">server</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="mi">80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="s">[::]:80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">server_name</span> <span class="s">example.com</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">root</span> <span class="s">/var/www/html/example.com</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">index</span> <span class="s">index.html</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">location</span> <span class="s">/</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">        <span class="kn">try_files</span> <span class="nv">$uri</span> <span class="nv">$uri/</span> <span class="p">=</span><span class="mi">404</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="p">}</span>
   </span></span><span class="line"><span class="cl"><span class="p">}</span>
   </span></span><span class="line"><span class="cl">    </span></span></code></pre></td></tr></tbody></table>

4. Edit the file associated with the `element` subdomain, such as `element.example.com`, and add the following information. Use the `element` subdomain name throughout, and append the `element` directory to the end of the `root` field.

   ```
    vi element.example.com
   ```

   File: /etc/nginx/sites-available/element.example.com

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt"> 1
   </span><span class="lnt"> 2
   </span><span class="lnt"> 3
   </span><span class="lnt"> 4
   </span><span class="lnt"> 5
   </span><span class="lnt"> 6
   </span><span class="lnt"> 7
   </span><span class="lnt"> 8
   </span><span class="lnt"> 9
   </span><span class="lnt">10
   </span><span class="lnt">11
   </span><span class="lnt">12
   </span><span class="lnt">13
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-nginx" data-lang="nginx"><span class="line"><span class="cl"><span class="k">server</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="mi">80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="s">[::]:80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">server_name</span> <span class="s">element.example.com</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">root</span> <span class="s">/var/www/html/element.example.com/element</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">index</span> <span class="s">index.html</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">location</span> <span class="s">/</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">        <span class="kn">try_files</span> <span class="nv">$uri</span> <span class="nv">$uri/</span> <span class="p">=</span><span class="mi">404</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="p">}</span>
   </span></span><span class="line"><span class="cl"><span class="p">}</span>
   </span></span><span class="line"><span class="cl">    </span></span></code></pre></td></tr></tbody></table>

5. Edit the file corresponding to the `matrix` subdomain, and add the following information. Use the `matrix` subdomain name in the `server_name` and `root` variables.

   ```
    vi matrix.example.com
   ```

   File: /etc/nginx/sites-available/matrix.example.com

   <table class="lntable"><tbody><tr><td class="lntd"><pre tabindex="0" class="chroma"><code><span class="lnt"> 1
   </span><span class="lnt"> 2
   </span><span class="lnt"> 3
   </span><span class="lnt"> 4
   </span><span class="lnt"> 5
   </span><span class="lnt"> 6
   </span><span class="lnt"> 7
   </span><span class="lnt"> 8
   </span><span class="lnt"> 9
   </span><span class="lnt">10
   </span><span class="lnt">11
   </span><span class="lnt">12
   </span><span class="lnt">13
   </span></code></pre></td><td class="lntd"><pre tabindex="0" class="chroma"><code class="language-nginx" data-lang="nginx"><span class="line"><span class="cl"><span class="k">server</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="mi">80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">listen</span> <span class="s">[::]:80</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">server_name</span> <span class="s">matrix.example.com</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">root</span> <span class="s">/var/www/html/matrix.example.com</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="kn">index</span> <span class="s">index.html</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">
   </span></span><span class="line"><span class="cl">    <span class="kn">location</span> <span class="s">/</span> <span class="p">{</span>
   </span></span><span class="line"><span class="cl">        <span class="kn">proxy_pass</span> <span class="s">http://localhost:8008</span><span class="p">;</span>
   </span></span><span class="line"><span class="cl">    <span class="p">}</span>
   </span></span><span class="line"><span class="cl"><span class="p">}</span>
   </span></span><span class="line"><span class="cl">    </span></span></code></pre></td></tr></tbody></table>

6. Use the NGINX syntax checker to validate the new files.

   ```
    sudo nginx -t
   ```

   The output indicates that the syntax is valid.

   ```
   nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
   nginx: configuration file /etc/nginx/nginx.conf test is successful

   ```

7. Restart NGINX to apply all the configuration changes.

   ```
    sudo systemctl restart nginx
   ```

[## Install Certbot and Generate _Let’s Encrypt_ Certificates](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#install-certbot-and-generate-lets-encrypt-certificates)

To use Element, you must enable encryption. The easiest way to do so is by using the _Hypertext Transfer Protocol_ (HTTP). HTTP allows users to authenticate the websites they visit and ensures their data is private. A website must possess a public key certificate signed by a trusted certificate authority before it can accept HTTPS requests. This ensures the owner of the certificate operates the website in question.

You can use [_Let’s Encrypt_](https://letsencrypt.org/) to generate certificates. This service grants basic SSL/TLS certificates to websites in an automated manner. [_Certbot_](https://certbot.eff.org/), a tool from the _Electronic Frontier Foundation_ (EFF), automates the entire certificate-granting operation. It identifies all of the relevant domains and manages the challenge requests and the granting process. It also makes all necessary changes to the NGINX configuration.

You can install Certbot using the `snap` utility, which is already pre-installed on Ubuntu. Certbot uses Python to request and configure the certificate, but all necessary Python components are included in the Certbot package.

1. Run the following commands to update Snap and verify the current version.

   ```
    sudo snap install core
    sudo snap refresh core
    snap version
   ```

   The `snap version` should output the following:

   ```
   username@localhost:~$ /etc/nginx/sites-available$ snap version
   snap    2.49.2
   snapd   2.49.2
   series  16
   ubuntu  18.04
   kernel  4.15.0-142-generic
   ```

   If Snap is not already installed, run the command `sudo apt install snapd` first.

2. Remove any existing Certbot packages using `apt-get remove`. This avoids possible conflicts.

   ```
    sudo apt-get remove certbot
   ```

3. Install Certbot.

   ```
    sudo snap install --classic certbot
   ```

   The Snap module confirms Certbot is installed.

   ```
   certbot 1.15.0 from Certbot Project (certbot-eff) installed

   ```

4. Configure a symbolic link to the Certbot directory using the `ln` command.

   ```
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
   ```

5. Use Certbot to generate certificates for your domains. Generate all three certificates with one command by using the `-d` option in front of each domain. Substitute your domain names in the following command:

   ```
    sudo certbot --nginx -d example.com -d element.example.com -d matrix.example.com
   ```

   You can run the client without the email address using the `--register-unsafely-without-email` at the end of the command:

   ```
    sudo certbot --nginx -d example.com -d element.example.com -d matrix.example.com --register-unsafely-without-email
   ```

   Certbot displays updates about the requests and challenges and then confirms the domains are successfully enabled. You might be required to supply some additional information if you have never used Certbot before.

   ```
   Saving debug log to /var/log/letsencrypt/letsencrypt.log
   Plugins selected: Authenticator nginx, Installer nginx
   Requesting a certificate for example.com and 2 more domains
   Performing the following challenges:
   http-01 challenge for element.example.com
   http-01 challenge for example.com
   http-01 challenge for matrix.example.com
   Waiting for verification...
   Cleaning up challenges
   Deploying Certificate to VirtualHost /etc/nginx/sites-enabled/example.com
   Deploying Certificate to VirtualHost /etc/nginx/sites-enabled/element.example.com
   Deploying Certificate to VirtualHost /etc/nginx/sites-enabled/matrix.example.com
   Redirecting all traffic on port 80 to ssl in /etc/nginx/sites-enabled/example.com
   Redirecting all traffic on port 80 to ssl in /etc/nginx/sites-enabled/element.example.com
   Redirecting all traffic on port 80 to ssl in /etc/nginx/sites-enabled/matrix.example.com

   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Congratulations! You have successfully enabled <https://example.com>,
   <https://element.example.com>, and <https://matrix.example.com>
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   ```

[## Configure Security Settings for Element](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#configure-security-settings-for-element)

To improve the security of your Element installation and deny unauthorized traffic attempts, configure the `ufw` firewall. In addition to allowing NGINX traffic, port **8448** must be unblocked. You can list all eligible applications using the `sudo ufw app list` command.

1. Allow `ufw` to accept `OpenSSH` connections, and enable `Nginx Full`. This allows access for both IPv4 and Ipv6 requests.

   ```
    sudo ufw allow OpenSSH
    sudo ufw allow 'Nginx Full'
   ```

2. Unblock port 8448 in the firewall.

   ```
    sudo ufw allow 8448
   ```

3. Enable the firewall.

   ```
    sudo ufw enable
   ```

4. Verify the firewall is active and properly configured using the `status` command.

   ```
    sudo ufw status
   ```

   ```
   Status: active
   To                         Action      From

   --                         ------      ----
   OpenSSH                    ALLOW       Anywhere
   Nginx Full                 ALLOW       Anywhere
   8448                       ALLOW       Anywhere
   OpenSSH (v6)               ALLOW       Anywhere (v6)
   Nginx Full (v6)            ALLOW       Anywhere (v6)
   8448 (v6)                  ALLOW       Anywhere (v6)

   ```

Important

The `ufw` allows `OpenSSH` traffic. Otherwise, you could lock yourself out of your Linode.

[## Enable and Test the Element Client](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#enable-and-test-the-element-client)

The easiest way to ensure Element works properly is to access the site and create a login.

1. Enable `nginx` and `matrix-synapse` in `systemctl`. This ensures they are activated whenever the Linode reboots. Restart the webserver to ensure all changes are applied.

   ```
    sudo systemctl enable nginx
    sudo systemctl enable matrix-synapse
    sudo systemctl restart nginx
   ```

2. Using a web browser, visit the Element landing page at [https://element.example.com](https://element.example.com/), substituting your domain name in the URL. Element displays the following login screen.

   ![Element landing page](/docs/guides/how-to-install-the-element-chat-app/Element-Landing-Page_small_hu1ab8be5e1245f7277e3cee1547919275_318003_62224626178d8aa871a0f0d68a5b7ec5.jpg "Element landing page")

3. To verify that Element can communicate with Matrix, create an account and ensure you can view the Element dashboard.

If the identity server is not configured, Element displays a warning message when logging in as some of the functionalities might be unavailable. This limitation does not affect core Element features such as chat and messaging.

[## Learn More About Matrix-Synapse and Element](https://www.linode.com/docs/guides/how-to-install-the-element-chat-app/#learn-more-about-matrix-synapse-and-element)

Compared to some open source projects, documentation about Element is limited. However, there are some helpful resources available.

1. Element provides a [_FAQ_](https://element.io/help) that answers many common questions.
2. The [_Element GitHub page_](https://github.com/vector-im/element-web) also provides more information.
3. There is also a page explaining Element’s [_advanced configuration options_](https://github.com/vector-im/element-web/blob/develop/docs/config.md).
4. Technical information about Matrix-Synapse can be found on a separate [_GitHub page_](https://github.com/matrix-org/synapse).

## More Information

You may wish to consult the following resources for additional information on this topic. While these are provided in the hope that they will be useful, please that we cannot vouch for the accuracy or timeliness of externally hosted materials.

- [Element](https://element.io/)
- [Matrix](https://matrix.org/)
- [Element GitHub Page](https://github.com/vector-im/element-web)
- [Matrix-Synapse](https://matrix.org/docs/projects/server/synapse)
- [Matrix-Synapse GitHub installation page](https://github.com/matrix-org/synapse/blob/master/INSTALL.md)
- [Matrix releases page](https://github.com/matrix-org/synapse/releases)
- [Element releases page](https://github.com/vector-im/element-web/releases)
- [NGINX](https://www.nginx.com/)
- [Lets Encrypt](https://letsencrypt.org/)
- [Certbot](https://certbot.eff.org/)
- [FAQ](https://element.io/help)
- [Elements advanced configuration options](https://github.com/vector-im/element-web/blob/develop/docs/config.md)
- [GitHub page](https://github.com/matrix-org/synapse)
