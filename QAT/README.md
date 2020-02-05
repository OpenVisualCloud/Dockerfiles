
### Install QAT

```bash
sudo yum update
printf '[intel-qat]\nname=Intel QAT\nbaseurl=https://download.01.org/QAT/repo\ngpgcheck=0\n' | sudo tee /etc/yum.repos.d/intel-qat.repo
sudo yum clean all
sudo yum install -y QAT
```

