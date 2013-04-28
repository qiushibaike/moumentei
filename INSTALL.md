冇问题安装指南
==============

事先准备
--------

* Ruby 1.8.7 
* Rails 3.2.x 
* RubyGems 1.8.x
* Bundler 1.0.x

安装前先 bundle install

### Linux开发环境搭建指南

打开终端，安装RVM，前提需要有curl
   
    $ sudo apt-get install curl 
    $ \curl -L https://get.rvm.io | bash -s stable
    $ rvm requirements   # 

根据RVM的要求安装相应的包，如git等
安装Ruby 1.8.7 或者Ruby Enterprise Edition（推荐使用REE）

    $ rvm install ree
    $ rvm use ree --default

安装 mercurial imagemagick mysql

    $ sudo apt-get install mercurial imagemagick mysql-server

安装 bundler
    
    $ gem i bundler

克隆代码

    $ git clone https://github.com/qiushibaike/moumentei

初始化 项目所用包

    $ cd moumentei
    $ bundle install

然后可以进行数据库的初始化

### Windows开发环境搭建指南

数据库可以在 www.mysql.com 下载并安装，或者安装[xampp](http://www.apachefriends.org/zh_cn/xampp.html)的版本

使用[RubyInstaller](http://rubyinstaller.org/)安装Ruby 1.8.7（打不开可以访问
http://rubyforge.org/projects/rubyinstaller/ ）。

下载1.8.7的安装包，以及DevKit安装包，并安装Ruby，安装时务必勾选“Add Ruby executables to your PATH”，如
未勾选，可以在系统设置里将Ruby安装目录的bin目录路径加入PATH环境变量。
将DevKit并解压至任意目录，如`C:\DevKit`，打开`cmd`配置DevKit，此时需保证ruby已存
于PATH中：

    > cd C:\DevKit
    > ruby dk.rb init
    > ruby dk.rb install

并为ruby安装bundler
 
    gem i bundler

下载 [msysgit](http://code.google.com/p/msysgit/) 并安装（选中“associate .sh
with msys”，以及“Run git from Windows command prompt option”）

克隆 https://github.com/qiushibaike/moumentei 至工作路径

    > git clone https://github.com/qiushibaike/moumentei

将 `vendor/libmysql.dll` 文件复制到 Ruby 安装目录下 `bin` 目录中，如 `C:/Ruby187/bin`

在项目目录中双击运行bundle.sh，或者在msys中进入项目工作路径，初始化项目所需的gem

    cd moumentei
    bundle install

下载安装 ImageMagick http://www.imagemagick.org/script/index.php ，上传处理图片需使用

### 数据库初始化

将 `config/database.default.yml` 复制为 `config/database.yml` 并配置其中的内容

如果需要创建数据库

    bundle exec rake db:setup
    
导入默认的范例数据，用户名`admin`，密码`123456`


### 启动服务

运行`ruby script/server`，并访问 `http://localhost:3000`，检查是否安装成功。


服务器部署
==========

服务器部署针对 Ubuntu 10.04 以上版本

对于新装机器，在deploy.rb中配置服务器信息，并在项目目录中执行 sprinkle
    
    sprinkle -s config/install.rb 

可以使用HOSTS覆盖部署目标服务器的信息

    sprinkle -s config/install.rb HOSTS=192.168.2.100

在deploy.rb中配置所需的用户名和密码、仓库用户名和密码

建立部署的目标目录结构

    cap deploy:setup

创建基本配置信息

    cap deploy:cold

检出代码并运行

    cap deploy


